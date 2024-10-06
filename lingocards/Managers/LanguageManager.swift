import Foundation
import Combine
import SwiftUI

class LanguageManager: ObservableObject {
    static let languageChangeNotification = Notification.Name("LanguageDidChange")
    @Published var currentLanguage: String {
        didSet {
            Defaults.appLanguage = currentLanguage
            setLanguage(currentLanguage)
            NotificationCenter.default.post(name: LanguageManager.languageChangeNotification, object: nil)

        }
    }
    
    private(set) var supportedLanguages: [String] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    private var bundle: Bundle?
    
    init() {
        self.currentLanguage = Defaults.appLanguage ?? Locale.current.languageCode ?? "en"
        self.supportedLanguages = getSupportedLanguages()
        setLanguage(currentLanguage)
    }
    
    private func getSupportedLanguages() -> [String] {
        guard let paths = Bundle.main.paths(forResourcesOfType: "lproj", inDirectory: nil) as [String]? else { return [] }

        let languages = paths
            .map { URL(fileURLWithPath: $0).deletingPathExtension().lastPathComponent }
            .filter { $0 != "Base" }
        return languages
    }
    
    private func setLanguage(_ language: String) {
            guard let path = Bundle.main.path(forResource: language, ofType: "lproj"),
                let bundle = Bundle(path: path) else {
                Logger.error("Could not find bundle for language \(language)")
                return
            }
            Logger.debug("Set language to \(language)")
            self.bundle = bundle
            UserDefaults.standard.set([language], forKey: "AppleLanguages")
            UserDefaults.standard.synchronize()
        }
    
    func localizedString(for key: String, arguments: CVarArg...) -> String {
        let format = bundle?.localizedString(forKey: key, value: nil, table: nil) ?? key
        return String(format: format, arguments: arguments)
    }
    
    func displayName(for languageCode: String) -> String {
        let identifier = Locale(identifier: languageCode)
        return identifier.localizedString(forIdentifier: languageCode) ?? languageCode
    }
}
