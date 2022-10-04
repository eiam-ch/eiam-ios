import AppAuth
import AuthenticationServices
import Foundation
import os

/// EIAMAuthorizationService interacts with the AppAuth SDK and provides a easy to use interface
class EIAMAuthorizationService: NSObject {
    /// the authentication configuration fetched from the discovery
    private var appAuthConfiguration: OIDServiceConfiguration?

    /// the provided configuration
    var configuration: EIAMConfiguration

    /// the AuthState object has to be persisted in the keychain, it contains the state of the AppAuth SDK (accessToken, refreshToken, ..)
    @UBKeychainStored(key: "ch.eiam.authState", defaultValue: .init(), accessibility: .afterFirstUnlock)
    private var persistedAuthState: CodableAuthState

    private var authState: OIDAuthState?

    private var queue = DispatchQueue(label: "ch.eiam.authorizationService")
    private var currentAuthorizationFlow: OIDExternalUserAgentSession?
    /// Initializer
    /// - Parameters:
    ///   - configuration: the configuration object provides the discovery endpoint and all client configurations
    init(configuration: EIAMConfiguration) {
        self.configuration = configuration
        super.init()

        queue.sync {
            self.authState = self.persistedAuthState.authState
        }
    }

    /// returns true if the client is authenticated
    public var isAuthenticated: Bool {
        authState?.isAuthorized ?? false
    }

    private typealias ConfigurationCallback = (Result<OIDServiceConfiguration, Error>) -> Void
    private func fetchConfiguration(callback: @escaping ConfigurationCallback) {
        OIDAuthorizationService.discoverConfiguration(forIssuer: configuration.discovery) { configuration, error in
            guard let config = configuration
            else {
                os_log(.error, "Error retrieving discovery document: %s", error?.localizedDescription ?? "Unknown error")
                if let error = error {
                    callback(.failure(error))
                } else {
                    fatalError()
                }
                return
            }
            callback(.success(config))
        }
    }

    /// starts the authentication flow
    /// - Parameters:
    ///   - viewController: a viewController has to be provided in order to display the system permission pop up
    ///   - callback: callback called when authenticated
    public typealias AuthenticateCallback = (Result<Void, EIAMAuthorizationError>) -> Void
    public func authenticate(viewController: UIViewController, callback: @escaping AuthenticateCallback) {
        guard let appAuthConfiguration = appAuthConfiguration else {
            fetchConfiguration { [weak self] result in
                guard let self = self else { return }
                switch result {
                    case let .success(config):
                        self.appAuthConfiguration = config
                        self.authenticate(viewController: viewController, callback: callback)
                    case let .failure(error):
                        callback(.failure(.objectNotReady(error)))
                }
            }
            return
        }
        // builds authentication request

        // We're using prompt=select_account (or alternatively prompt=login) to trigger
        // user-interaction when logging in. This avoids non-interactive SSO (opening and
        // closing browser directly if user is already logged in on this device/browser).
        let request = OIDAuthorizationRequest(configuration: appAuthConfiguration,
                                              clientId: configuration.clientID,
                                              clientSecret: configuration.clientSecret,
                                              // offline_access required for obtaining a refresh token
                                              scopes: [OIDScopeOpenID, "offline_access"],
                                              redirectURL: configuration.redirectURI,
                                              responseType: OIDResponseTypeCode,
                                              additionalParameters: ["prompt": "select_account"])

        currentAuthorizationFlow = OIDAuthState.authState(byPresenting: request, presenting: viewController) { [weak self] authState, error in
            guard let self = self else { return }

            self.queue.async { [weak self] in
                self?.setAuthState(authState)
            }

            if let authState = authState {
                if #available(iOS 12.0, *) {
                    os_log(.debug, "Got authorization tokens. Access token: %s", authState.lastTokenResponse?.accessToken ?? "nil")
                }
                NotificationCenter.default.post(.init(name: .eIAMAuthStateDidChange))
                callback(.success(()))
            } else {
                if #available(iOS 12.0, *) {
                    os_log(.debug, "Authorization error:  %s", error?.localizedDescription ?? "Unknown error")
                }

                if #available(iOS 12.0, *),
                   let error = error {
                    let nsError = error as NSError
                    if nsError.domain == OIDGeneralErrorDomain,
                       let underlyingError = nsError.userInfo[NSUnderlyingErrorKey] as? NSError,
                       underlyingError.domain == ASWebAuthenticationSessionErrorDomain,
                       underlyingError.code == ASWebAuthenticationSessionError.canceledLogin.rawValue {
                        callback(.failure(.loginCanceled))
                    } else {
                        callback(.failure(.appAuthError(error)))
                    }
                } else {
                    fatalError()
                }
            }
        }
    }

    /// structure that contains all tokens
    public struct Tokens {
        let accessToken: String?
        let idToken: String?
        let refreshToken: String?
    }

    /// Get the tokens. If the current token is expired the AppAuth automatically fetches a fresh token.
    /// If a fresh token is needed in either case set the optional forceFresh parameter to true
    /// - Parameters:
    ///   - forceFresh: if true a fresh token is fetched
    ///   - callback: callback is called with token results
    public typealias GetTokenCallback = (Result<Tokens, EIAMGetTokenError>) -> Void
    public func getToken(forceFresh: Bool = false, _ callback: @escaping GetTokenCallback) {
        queue.async { [weak self] in
            guard let self = self else { return }

            guard let authState = self.authState else {
                callback(.failure(.objectNotReady))
                return
            }

            if forceFresh {
                authState.setNeedsTokenRefresh()
            }

            let semaphore = DispatchSemaphore(value: 0)

            authState.performAction(freshTokens: { accessToken, idToken, error in

                if let error = error {
                    let nsError = error as NSError
                    if nsError.domain == OIDOAuthTokenErrorDomain, nsError.code == OIDErrorCodeOAuth.invalidGrant.rawValue {
                        // If we encounter an invalid grant error, we pass it back as recoverable, so the app can show the login button again
                        callback(.failure(.recoverableAuthError))
                    } else {
                        callback(.failure(.appAuthError(nsError)))
                    }
                } else {
                    callback(.success(.init(accessToken: accessToken, idToken: idToken, refreshToken: authState.refreshToken)))
                }

                semaphore.signal()
            }, additionalRefreshParameters: nil, dispatchQueue: .main)

            semaphore.wait()
            self.setAuthState(authState)
        }
    }

    /// Deletes all locally stored token informations
    public func logout(callback: (() -> Void)? = nil) {
        queue.async { [weak self] in
            guard let self = self else { return }
            self.setAuthState(nil)
            DispatchQueue.main.async {
                NotificationCenter.default.post(.init(name: .eIAMAuthStateDidChange))
                callback?()
            }
        }
    }

    private var userInfoDataTask: URLSessionDataTask?

    /// Performs the user info request and returns its information
    /// - Parameters:
    ///   - urlSession: a optional urlSession can be provided to perform the request on
    ///   - callback: returns either the raw user info data or an error
    public typealias UserInfoCallback = (Result<Data, EIAMUserInfoError>) -> Void
    public func userInfo(urlSession: URLSession = URLSession(configuration: .ephemeral), callback: @escaping UserInfoCallback) {
        guard isAuthenticated else {
            callback(.failure(.notAuthenticated))
            return
        }

        guard let appAuthConfiguration = appAuthConfiguration else {
            fetchConfiguration { [weak self] result in
                guard let self = self else { return }
                switch result {
                    case let .success(config):
                        self.appAuthConfiguration = config
                        self.userInfo(urlSession: urlSession, callback: callback)
                    case .failure:
                        callback(.failure(.noUserinfoEndpoint))
                }
            }
            return
        }

        guard let userInfoEndpoint = appAuthConfiguration.discoveryDocument?.userinfoEndpoint else {
            callback(.failure(.noUserinfoEndpoint))
            return
        }

        getToken { [weak self] result in
            guard let self = self else { return }
            switch result {
                case let .success(tokens):
                    var req = URLRequest(url: userInfoEndpoint)
                    req.setValue("Bearer \(tokens.accessToken ?? "")", forHTTPHeaderField: "Authorization")
                    self.userInfoDataTask = urlSession.dataTask(with: req) { [weak self] data, _, error in
                        guard let self = self else { return }
                        self.userInfoDataTask = nil
                        DispatchQueue.main.async {
                            if let data = data {
                                callback(.success(data))
                            } else if let error = error {
                                callback(.failure(.networkingError(error)))
                            } else {
                                callback(.failure(.noData))
                            }
                        }
                    }
                    self.userInfoDataTask?.resume()
                case let .failure(error):
                    callback(.failure(.tokenError(error)))
            }
        }
    }

    private func setAuthState(_ authState: OIDAuthState?) {
        dispatchPrecondition(condition: .onQueue(queue))

        authState?.stateChangeDelegate = self
        self.authState = authState
        var newWrapper = CodableAuthState()
        newWrapper.authState = authState
        persistedAuthState = newWrapper
    }
}

public extension Notification.Name {
    /// This notification is posted every time the authState was changed
    static let eIAMAuthStateDidChange = Notification.Name("ch.eIAM.authenticateStateDidChange")
}

extension EIAMAuthorizationService: OIDAuthStateChangeDelegate {
    func didChange(_ state: OIDAuthState) {
        if #available(iOS 12.0, *) {
            os_log(.info, "EIAM authorizationstate did Change to %s", state.debugDescription)
        }
        NotificationCenter.default.post(.init(name: .eIAMAuthStateDidChange))
    }
}
