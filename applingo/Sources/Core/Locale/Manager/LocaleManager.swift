import Foundation

final class LocaleManager: ObservableObject {
    static let shared = LocaleManager()
    
    @Published private(set) var currentLocale: LocaleType {
        didSet {
            if AppStorage.shared.appLocale != currentLocale {
                AppStorage.shared.appLocale = currentLocale
                updateBundle()
            }
        }
    }
    
    private(set) var supportedLocales: [LocaleType] = []
    private var bundle: Bundle?
    
    private init() {
        self.currentLocale = Self.getInitialLocale()
        self.supportedLocales = getSupportedLocales()
        self.updateBundle()
        Logger.debug("[LocaleManager]: Initialize manager with \(self.currentLocale.asString)")
    }
    
    private static func getInitialLocale() -> LocaleType {
        return AppStorage.shared.appLocale
    }
    
    private func getSupportedLocales() -> [LocaleType] {
        return LocaleType.allCases
    }
    
    private func updateBundle() {
        guard let path = Bundle.main.path(forResource: currentLocale.asString, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            Logger.warning("Could not find bundle for locale \(currentLocale.asString). Falling back to default.")
            self.bundle = Bundle.main
            return
        }
        
        Logger.debug("[LocaleManager]: Set locale to \(currentLocale.asString)")
        self.bundle = bundle
    }
    
    func setLocale(_ locale: LocaleType) {
        self.currentLocale = locale
    }
    
    func localizedString(for key: String, arguments: CVarArg...) -> String {
        let format = bundle?.localizedString(forKey: key, value: nil, table: nil) ?? key
        return String(format: format, arguments: arguments).lowercased()
    }
}
