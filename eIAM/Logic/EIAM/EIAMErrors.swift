import Foundation

enum EIAMAuthorizationError: Error {
    /// the service is not yet ready (configuration is not fetched)
    case objectNotReady(Error?)
    /// User canceled login
    case loginCanceled
    /// AppAuth SKD returned a error
    case appAuthError(Error)

    var description: String {
        switch self {
            case let .appAuthError(error):
                return "EIAMAuthorizationError.appAuthError(\(error.localizedDescription))"
            case .loginCanceled:
                return "EIAMAuthorizationError.loginCanceled"
            case let .objectNotReady(error):
                return "EIAMAuthorizationError.objectNotReady(\(error?.localizedDescription ?? "N/A"))"
        }
    }
}

enum EIAMGetTokenError: Error {
    /// the service is not yet ready (configuration is not fetched)
    case objectNotReady
    /// AppAuth SKD returned a error
    case appAuthError(Error)
    /// Recoverable auth error
    case recoverableAuthError

    var description: String {
        switch self {
            case let .appAuthError(error):
                return "EIAMGetTokenError.appAuthError(\(error.localizedDescription))"
            case .objectNotReady:
                return "EIAMGetTokenError.objectNotReady"
            case .recoverableAuthError:
                return "FLGetTokenError.recoverableAuthError"
        }
    }
}

enum EIAMUserInfoError: Error {
    /// the client is not authorized
    case notAuthenticated
    /// the discovery does not provide a user info endpoint
    case noUserinfoEndpoint
    /// a error occurred while getting a token
    case tokenError(EIAMGetTokenError)
    /// a networking error occurred while fetching user info
    case networkingError(Error)
    /// the user info endpoint returned no data
    case noData

    var description: String {
        switch self {
            case .notAuthenticated:
                return "EIAMUserInfoError.notAuthenticated"
            case .noUserinfoEndpoint:
                return "EIAMUserInfoError.noUserinfoEndpoint"
            case let .tokenError(wrappedError):
                return "EIAMUserInfoError.tokenError(\(wrappedError.description))"
            case let .networkingError(wrappedError):
                return "EIAMUserInfoError.networkingError(\(wrappedError.localizedDescription))"
            case .noData:
                return "EIAMUserInfoError.noData"
        }
    }
}
