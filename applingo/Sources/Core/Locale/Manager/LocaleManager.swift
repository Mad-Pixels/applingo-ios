import Foundation

final class LocaleManager: ObservableObject {
    static let shared = LocaleManager()
    
    @Published private(set) var currentLocale: LocaleType {
        didSet {
            Logger.debug("[LocaleManager]: Locale changed from \(oldValue.asString) to \(currentLocale.asString)")
            handleLocaleChange()
        }
    }
    
    @Published private(set) var viewId = UUID()
    private(set) var supportedLocales: [LocaleType] = []
    private var bundle: Bundle?
    
    static let localeDidChangeNotification = Notification.Name("LocaleManagerDidChangeLocale")
    
    private init() {
        // Используем статические методы
        self.currentLocale = Self.getInitialLocale()
        self.supportedLocales = Self.getSupportedLocales()
        self.updateBundle()
        Logger.debug("[LocaleManager]: Initialize manager with \(self.currentLocale.asString)")
    }
    
    // Делаем методы статическими
    private static func getInitialLocale() -> LocaleType {
        return AppStorage.shared.appLocale
    }
    
    private static func getSupportedLocales() -> [LocaleType] {
        return LocaleType.allCases
    }
    
    private func handleLocaleChange() {
        if AppStorage.shared.appLocale != currentLocale {
            Logger.debug("[LocaleManager]: Updating app locale")
            
            updateBundle()
            AppStorage.shared.appLocale = currentLocale
            
            DispatchQueue.main.async {
                self.viewId = UUID()
                NotificationCenter.default.post(name: Self.localeDidChangeNotification, object: nil)
            }
        }
    }
    
    func setLocale(_ locale: LocaleType) {
        guard locale != currentLocale else {
            Logger.debug("[LocaleManager]: Same locale selected, ignoring")
            return
        }
        
        Logger.debug("[LocaleManager]: Setting new locale: \(locale.asString)")
        self.currentLocale = locale
    }
    
    private func updateBundle() {
        guard let path = Bundle.main.path(forResource: currentLocale.asString, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            Logger.warning("[LocaleManager]: Could not find bundle for locale \(currentLocale.asString). Falling back to default.")
            self.bundle = Bundle.main
            return
        }
        
        Logger.debug("[LocaleManager]: Bundle updated for locale: \(currentLocale.asString)")
        self.bundle = bundle
    }
    
    func localizedString(for key: String, arguments: CVarArg...) -> String {
        let format = bundle?.localizedString(forKey: key, value: nil, table: nil) ?? key
        return String(format: format, arguments: arguments).lowercased()
    }
}
