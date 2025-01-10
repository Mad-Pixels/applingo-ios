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
        self.supportedLocales = Self.getSupportedLocales()
        self.currentLocale = Self.getInitialLocale()
        self.updateBundle()
    }
    
    private static func getInitialLocale() -> LocaleType {
        return AppStorage.shared.appLocale
    }
    
    private static func getSupportedLocales() -> [LocaleType] {
        return LocaleType.allCases
    }
    
    private func handleLocaleChange() {
        if AppStorage.shared.appLocale != currentLocale {
            updateBundle()
            AppStorage.shared.appLocale = currentLocale
            
            DispatchQueue.main.async { [weak self] in
                self?.objectWillChange.send()
                NotificationCenter.default.post(name: Self.localeDidChangeNotification, object: nil)
            }
        }
    }
    
    func setLocale(_ locale: LocaleType) {
        guard locale != currentLocale else {
            return
        }
        self.currentLocale = locale
    }
    
    private func updateBundle() {
        guard let path = Bundle.main.path(forResource: currentLocale.asString, ofType: "lproj") else {
            self.bundle = Bundle.main
            return
        }
        guard let bundle = Bundle(path: path) else {
            self.bundle = Bundle.main
            return
        }
        self.bundle = bundle
    }
    
    func localizedString(for key: String, arguments: CVarArg...) -> String {
        let format = bundle?.localizedString(forKey: key, value: nil, table: nil) ?? key
        return String(format: format, arguments: arguments).lowercased()
    }
}
