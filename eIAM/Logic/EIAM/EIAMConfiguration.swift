import Foundation

struct EIAMConfiguration {
    /// the discovery endpoint
    let discovery: URL
    /// clientID to use
    let clientID: String
    /// the redirect URI to use (for deployment targets lower than iOS 11 this has to be registered in the app target)
    let redirectURI: URL
}
