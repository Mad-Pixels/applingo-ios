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
            
            // Проверим текущий bundle перед обновлением
            if let currentPath = bundle?.bundlePath {
                Logger.debug("[LocaleManager]: Current bundle path: \(currentPath)")
            }
            
            updateBundle()
            AppStorage.shared.appLocale = currentLocale
            
            // Проверим новый bundle после обновления
            if let newPath = bundle?.bundlePath {
                Logger.debug("[LocaleManager]: New bundle path: \(newPath)")
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.objectWillChange.send()
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
        guard let path = Bundle.main.path(forResource: currentLocale.asString, ofType: "lproj") else {
            Logger.warning("[LocaleManager]: Could not find path for locale \(currentLocale.asString)")
            self.bundle = Bundle.main
            return
        }
        
        guard let bundle = Bundle(path: path) else {
            Logger.warning("[LocaleManager]: Could not create bundle for path \(path)")
            self.bundle = Bundle.main
            return
        }
        
        Logger.debug("[LocaleManager]: Bundle updated for locale: \(currentLocale.asString), path: \(path)")
        self.bundle = bundle
    }
    
    func localizedString(for key: String, arguments: CVarArg...) -> String {
        let format = bundle?.localizedString(forKey: key, value: nil, table: nil) ?? key
        return String(format: format, arguments: arguments).lowercased()
    }
}
