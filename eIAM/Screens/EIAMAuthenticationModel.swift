//
//  AuthenticationModel.swift
//  eIAM
//
//  Created by Bastian Morath on 27.04.22.
//  Copyright © 2022 Ubique Innovation AG. All rights reserved.
//

import Combine
import Foundation
import SwiftUI
class EIAMAuthenticationModel: ObservableObject {
    static let instance = EIAMAuthenticationModel()

    // MARK: - Public

    @Published var user: User = .init(firstName: nil, lastName: nil, email: nil)
    @Published var authState: AuthState = .initial

    class User: ObservableObject {
        @Published var firstName: String?
        @Published var lastName: String?
        @Published var email: String?

        init(firstName: String?, lastName: String?, email: String?) {
            self.firstName = firstName
            self.lastName = lastName
            self.email = email
        }
    }

    enum AuthState {
        case initial
        case loggedIn(tokens: EIAMAuthorizationService.Tokens)
        case error(message: String)
    }

    func setEnvironment(environment: StagingEnvironment, callback: @escaping () -> Void) {
        authorizationService.logout {
            StagingEnvironment.current = environment

            self.authorizationService = EIAMAuthorizationService(configuration: StagingEnvironment.current.configuration)

            self.authStateChanged()

            self.authorizationService.getToken { _ in
                callback()
            }
        }
    }

    func login() {
        DispatchQueue.main.async {
            self.authorizationService.authenticate(viewController: UIApplication.shared.windows.first!.rootViewController!) { [weak self] res in
                switch res {
                    case .success:
                        self?.updateAccessToken()
                    case let .failure(err):
                        switch err {
                            case let .appAuthError(error):
                                self?.authState = .error(message: "AppAuth Error: \(error.localizedDescription)")
                            case let .objectNotReady(error):
                                if let error = error {
                                    self?.authState = .error(message: "Initialisation Error: \(error.localizedDescription)")
                                } else {
                                    self?.authState = .initial
                                }
                            case .loginCanceled:
                                self?.authState = .error(message: "LoginCanceled")
                        }
                }
            }
        }
    }

    func updateAccessToken(forceRefresh: Bool = false, isDiagnose: Bool = false, completionHandler: EIAMAuthorizationService.GetTokenCallback? = nil) {
        guard authorizationService.isAuthenticated else { return }
        authorizationService.getToken(forceFresh: forceRefresh) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                    case let .success(tokens):
                        self.authState = .loggedIn(tokens: tokens)
                    case let .failure(error):
                        if !isDiagnose {
                            self.authState = .error(message: error.description)
                        }
                }
                completionHandler?(result)
            }
        }
    }

    func logout() {
        authorizationService.logout {
            self.authState = .initial
        }
    }

    func makeTestRequest(completionHandler: @escaping DemoBackend.TestRequestCallback) {
        backend.testRequest(callback: completionHandler)
    }

    func loadUserInfo(callback: EIAMAuthorizationService.UserInfoCallback? = nil) {
        authorizationService.userInfo { [weak self] result in
            guard let self = self else { return }
            switch result {
                case let .success(data):
                    if let dict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    {
                        self.user.firstName = dict["given_name"] as? String
                        self.user.lastName = dict["family_name"] as? String
                        self.user.email = dict["email"] as? String
                    }
                case .failure:
                    self.user.firstName = nil
                    self.user.lastName = nil
                    self.user.email = nil
            }
            callback?(result)
        }
    }

    // MARK: - State

    private var anyCancellable: AnyCancellable?
    private(set) var authorizationService: EIAMAuthorizationService! {
        didSet {
            self.backend.service = authorizationService
        }
    }
    private var backend = DemoBackend.instance

    // MARK: - Init

    private init() {
        authorizationService = EIAMAuthorizationService(configuration: StagingEnvironment.current.configuration)
        self.updateAccessToken()
        self.authStateChanged()
        NotificationCenter.default.addObserver(self, selector: #selector(authStateChanged), name: .eIAMAuthStateDidChange, object: nil)
        anyCancellable = user.objectWillChange.sink { [weak self] _ in
            self?.objectWillChange.send()
        }
        self.backend.service = authorizationService
    }

    @objc private func authStateChanged() {
        self.loadUserInfo()
    }
}
