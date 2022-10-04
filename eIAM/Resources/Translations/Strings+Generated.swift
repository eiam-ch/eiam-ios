// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable function_parameter_count identifier_name line_length type_body_length
 enum UBLocalized {
   enum Key : String {
    /// App Name
     case app_name
    /// Diagnose
     case authenticated_diagnose_button_title
    /// Hier bekommen sie detaillierte technische Informationen
     case authenticated_diagnose_text
    /// Abmelden
     case authenticated_logout_button_title
    /// Ergfolgreich angemeldet!
     case authenticated_title
    /// Zurück
     case back_button
    /// Abbrechen
     case cancel_button
    /// Schliessen
     case close_button
    /// Weiter
     case continue_button
    /// Löschen
     case delete_button
    /// Diagnose
     case diagnose_title
    /// Fertig
     case done_button
    /// Fehler
     case error_title
    /// Wählen Sie einen Staging environment:
     case home_choose_environment
    /// eIAM ist das zentrale Zugriffs- und Berechtigungssystem der Bundesverwaltung für Webapplikationen, und native Mobile Apps.
     case home_description
    /// Login Starten
     case home_login_button_title
    /// eGovernment Identity & \nAccess Management
     case home_subtitle
    /// eIAM
     case home_title
    /// Vereinfacht erklärt, ist eIAM die zentrale Login-Infrastruktur des Bundes mit dem Ziel, dass nicht für jede Applikation ein eigenes Loginverfahren entwickelt werden muss.\n\nDank dieser Zentralisierung werden Kosten gespart und alle Applikationen können mit denselben Zugangsdaten verwendet werden.\n\nEs spielt dabei keine Rolle, wie und wo die Zielapplikation betrieben wird, eIAM kann Applikationen auf der ganzen Welt bedienen.
     case information_text_bottom
    /// eIAM ist das zentrale Zugriffs- und Berechtigungssystem der Bundesverwaltung für Webapplikationen, und native Mobile Apps.
     case information_text_top
    /// Information
     case information_title
    /// https://www.eiam.admin.ch/
     case Information_url_link
    /// eIAM
     case Information_url_title
    /// https://youtu.be/6rWNYl6cgA8
     case Information_youtubevideo_url
    /// de
     case language_key
    /// OK
     case ok_button
    /// Erneut versuchen
     case retry_button
    /// Sichern
     case save_button
  }

  /// App Name
   static var app_name: String { return UBLocalized.tr(Key.app_name) }
  /// Diagnose
   static var authenticated_diagnose_button_title: String { return UBLocalized.tr(Key.authenticated_diagnose_button_title) }
  /// Hier bekommen sie detaillierte technische Informationen
   static var authenticated_diagnose_text: String { return UBLocalized.tr(Key.authenticated_diagnose_text) }
  /// Abmelden
   static var authenticated_logout_button_title: String { return UBLocalized.tr(Key.authenticated_logout_button_title) }
  /// Ergfolgreich angemeldet!
   static var authenticated_title: String { return UBLocalized.tr(Key.authenticated_title) }
  /// Zurück
   static var back_button: String { return UBLocalized.tr(Key.back_button) }
  /// Abbrechen
   static var cancel_button: String { return UBLocalized.tr(Key.cancel_button) }
  /// Schliessen
   static var close_button: String { return UBLocalized.tr(Key.close_button) }
  /// Weiter
   static var continue_button: String { return UBLocalized.tr(Key.continue_button) }
  /// Löschen
   static var delete_button: String { return UBLocalized.tr(Key.delete_button) }
  /// Diagnose
   static var diagnose_title: String { return UBLocalized.tr(Key.diagnose_title) }
  /// Fertig
   static var done_button: String { return UBLocalized.tr(Key.done_button) }
  /// Fehler
   static var error_title: String { return UBLocalized.tr(Key.error_title) }
  /// Wählen Sie einen Staging environment:
   static var home_choose_environment: String { return UBLocalized.tr(Key.home_choose_environment) }
  /// eIAM ist das zentrale Zugriffs- und Berechtigungssystem der Bundesverwaltung für Webapplikationen, und native Mobile Apps.
   static var home_description: String { return UBLocalized.tr(Key.home_description) }
  /// Login Starten
   static var home_login_button_title: String { return UBLocalized.tr(Key.home_login_button_title) }
  /// eGovernment Identity & \nAccess Management
   static var home_subtitle: String { return UBLocalized.tr(Key.home_subtitle) }
  /// eIAM
   static var home_title: String { return UBLocalized.tr(Key.home_title) }
  /// Vereinfacht erklärt, ist eIAM die zentrale Login-Infrastruktur des Bundes mit dem Ziel, dass nicht für jede Applikation ein eigenes Loginverfahren entwickelt werden muss.\n\nDank dieser Zentralisierung werden Kosten gespart und alle Applikationen können mit denselben Zugangsdaten verwendet werden.\n\nEs spielt dabei keine Rolle, wie und wo die Zielapplikation betrieben wird, eIAM kann Applikationen auf der ganzen Welt bedienen.
   static var information_text_bottom: String { return UBLocalized.tr(Key.information_text_bottom) }
  /// eIAM ist das zentrale Zugriffs- und Berechtigungssystem der Bundesverwaltung für Webapplikationen, und native Mobile Apps.
   static var information_text_top: String { return UBLocalized.tr(Key.information_text_top) }
  /// Information
   static var information_title: String { return UBLocalized.tr(Key.information_title) }
  /// https://www.eiam.admin.ch/
   static var Information_url_link: String { return UBLocalized.tr(Key.Information_url_link) }
  /// eIAM
   static var Information_url_title: String { return UBLocalized.tr(Key.Information_url_title) }
  /// https://youtu.be/6rWNYl6cgA8
   static var Information_youtubevideo_url: String { return UBLocalized.tr(Key.Information_youtubevideo_url) }
  /// de
   static var language_key: String { return UBLocalized.tr(Key.language_key) }
  /// OK
   static var ok_button: String { return UBLocalized.tr(Key.ok_button) }
  /// Erneut versuchen
   static var retry_button: String { return UBLocalized.tr(Key.retry_button) }
  /// Sichern
   static var save_button: String { return UBLocalized.tr(Key.save_button) }
}
// swiftlint:enable function_parameter_count identifier_name line_length type_body_length

// MARK: - Implementation Details

class UBLocalizer {
    static var `default` = UBLocalizer()
    func makeDefault() {
        UBLocalizer.default = self
    }

    func translateWithDefaultLanguage(_ key: UBLocalized.Key, _ table: String = "", _ args: CVarArg...) -> String {
        let format = BundleToken.bundle.localizedString(forKey: key.rawValue, value: nil, table: table)
        return String(format: format, locale: Locale.current, arguments: args)
    }

    public func translate(_ key: UBLocalized.Key, languageKey: String? = nil, table: String = "", _ args: CVarArg...) -> String {
      guard let languageKey = languageKey else {
        return self.translateWithDefaultLanguage(key, table, args)
      }

      guard let bundlePath = BundleToken.bundle.path(forResource: languageKey, ofType: "lproj"), let bundle = Bundle(path: bundlePath)
      else { return "" }
      return String(format: NSLocalizedString(key.rawValue, bundle: bundle, value: "", comment: ""), locale: Locale.current, arguments: args)
    }
}

private extension UBLocalized {
    private static func tr(_ key: UBLocalized.Key, _ table: String = "", _ args: CVarArg...) -> String {
      UBLocalizer.default.translate(key, table: table, args)
    }
}

extension UBLocalized {
    public static func translate(_ key: UBLocalized.Key, languageKey: String? = nil, table: String = "", _ args: CVarArg...) -> String {
        UBLocalizer.default.translate(key, languageKey: languageKey, table: table, args)
    }
}


// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
