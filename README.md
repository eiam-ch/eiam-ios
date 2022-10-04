# eiam-ios

<p align="center">
  <img width="200" height="auto" src="/eIAM/Resources/Images/Images.xcassets/AppIcon.appiconset/1024.png">
</p>
<p align="center">
   <!-- App Store -->
    <a href="https://apps.apple.com/ch/app/eiam-developer/id6443578396">
      <img height="40" src="https://developer.apple.com/assets/elements/badges/download-on-the-app-store.svg" alt="Download on the App Store" />
    </a>
</p>


eiam-ios is a sample authentication project which demonstrates best practices on how to integrate OpenID Connect into an iOS app. Internally it depends using [SPM](https://www.swift.org/package-manager/) on the open source project [AppAuth-iOS](https://github.com/openid/AppAuth-iOS) which does the heavy lifting and implements the [OpenID Connect specification](https://openid.net/specs/openid-connect-core-1_0.html).
[AppAuth-iOS](https://github.com/openid/AppAuth-iOS) uses the [ASWebAuthenticationSession](https://developer.apple.com/documentation/authenticationservices/aswebauthenticationsession) on the supported operating system version which allows the app to have the advantages of SSO. Therefore a user can use its ongoing session of the Safari mobile browser to log in to the app.
[AppAuth-iOS](https://github.com/openid/AppAuth-iOS) stores the current authentication state in a [OIDAuthState](https://github.com/openid/AppAuth-iOS/blob/master/Source/AppAuthCore/OIDAuthState.h) object, eiam-ios uses the [NSKeyedArchiver](https://developer.apple.com/documentation/foundation/nskeyedarchiver) to encode and decode this object and stores it safely in the keychain.

The app allows the user to login to 3 Enviroments [(REF/ABN/PROD)](/eIAM/Logic/EIAMConfiguration%2BEnviroment.swift) and displays informations about the tokens.

All authorization related code can be found in the [Logic/EIAM](/eIAM/Logic/EIAM) subfolder. The `EIAMAuthorizationService` is the entry point when authenticating a user.

## Auth Flow

### init(configuration:initializedCallback:)
The initializer sets up the service with the given [configuration](/eIAM/Logic/EIAM/EIAMConfiguration.swift). The configurations for the different eiam enviroments can be found [here](https://github.com/UbiqueInnovation/eiam-ios/blob/develop/eIAM/Logic/EIAMConfiguration%2BEnviroment.swift).
The initializedCallback is called as soon as the object is ready to use.

### func authenticate(viewController:callback:)
By calling this method the authentication flow is started. A ViewController has to be passed to present the [ASWebAuthenticationSession](https://developer.apple.com/documentation/authenticationservices/aswebauthenticationsession). The callback is called with a result type containing either success or the error.

### var isAuthenticated: Bool
This computed property can be used to check if a user is authenticated.

### func userInfo(urlSession:callback:)
Performs the user info request if one is advertised in the discovery and returns its information. An optional URLSession can be passed or else a URLSession with an ephemeral configuration will be used.

### func getToken(forceFresh:callback:)
By calling this method the access, refresh and id token can be obtained. If the currently stored token expires the SDK will try to renew it using the refresh token. If the forceFresh Parameter is set to true a new token will be fetched even if not expired.

### func logout(callback:)
When this method is called the locally stored tokens will be deleted. The user will not be logged out of the SSO session but only within the app scope.

## OIDC Best Practises

✅ OIDC Flow: Authorization code flow

✅ Use PKCE

✅ Use system browser (SFSafariViewController)

✅ Set prompt=select_account / prompt=login to ensure user-interaction while login (instead of non-interactive SSO) 

✅ Store tokens (encrypted) in keychain 

✅ No tokens in app cache (an ephemeral URLSession is used)

✅ Use certificate pinning for requests to IdP

✅ Logout: drop all tokens

✅ Error handling 

✅ Time handling access/refresh token (before expired)

