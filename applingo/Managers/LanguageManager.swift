import Foundation
import Combine
import SwiftUI

final class LanguageManager: ObservableObject {
    static let shared = LanguageManager()
    
    @Published var currentLanguage: String {
        didSet {
            var a = AppStorage.shared.appLocale.rawValue
            a = currentLanguage
            setLanguage(currentLanguage)
        }
    }

    static let languageChangeNotification = Notification.Name("LanguageDidChange")

    private(set) var supportedLanguages: [String] = []
    private var bundle: Bundle?

    init() {
        self.currentLanguage = Self.getInitialLanguage()
        self.supportedLanguages = getSupportedLanguages()

        setLanguage(currentLanguage)
        Logger.debug("[LanguageManager]: Initialize manager with \(currentLanguage)")
    }

    private static func getInitialLanguage() -> String {
        if #available(iOS 16.0, *) {
            return AppStorage.shared.appLocale.asString ?? Locale.current.language.languageCode?.identifier ?? "en"
        } else {
            return AppStorage.shared.appLocale.asString ?? Locale.current.languageCode ?? "en"
        }
    }

    private func getSupportedLanguages() -> [String] {
        guard let paths = Bundle.main.paths(forResourcesOfType: "lproj", inDirectory: nil) as [String]? else { return [] }

        let languages = paths
            .map { URL(fileURLWithPath: $0).deletingPathExtension().lastPathComponent }
            .filter { $0 != "Base" }

        Logger.debug("[LanguageManager]: Supported languages: \(languages)")
        return languages
    }

    private func setLanguage(_ language: String) {
        guard let path = Bundle.main.path(forResource: language, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            
            Logger.warning("Could not find bundle for language \(language). Falling back to default language.")
            self.bundle = Bundle.main
            return
        }
        
        Logger.debug("[LanguageManager]: Set language to \(language)")
        self.bundle = bundle
//        var a = AppStorage.shared.appLocale.rawValue
//        a = currentLanguage
//        AppStorage.shared.appLocale = language
    }
    
    func localizedString(for key: String, arguments: CVarArg...) -> String {
        let format = bundle?.localizedString(forKey: key, value: nil, table: nil) ?? key
        return String(format: format, arguments: arguments).lowercased()
    }
    
    func displayName(for languageCode: String) -> String {
        let identifier = Locale(identifier: languageCode)
        return identifier.localizedString(forIdentifier: languageCode)?.lowercased() ?? languageCode.lowercased()
    }
}
