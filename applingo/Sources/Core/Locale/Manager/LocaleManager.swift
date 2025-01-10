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
    
    static let localeDidChangeNotification = Notification.Name("LocaleManagerDidChangeLocale")
    
    private(set) var supportedLocales: [LocaleType] = []
    private var bundle: Bundle?
    
    private init() {
        self.supportedLocales = Self.getSupportedLocales()
        self.currentLocale = Self.getInitialLocale()
        self.updateBundle()
    }
    
    func setLocale(_ locale: LocaleType) {
        guard locale != currentLocale else { return }
        self.currentLocale = locale
    }
    
    func localizedString(for key: String, arguments: CVarArg...) -> String {
        let format = bundle?.localizedString(forKey: key, value: nil, table: nil) ?? key
        return String(format: format, arguments: arguments).lowercased()
    }
    
    private static func getInitialLocale() -> LocaleType {
        AppStorage.shared.appLocale
    }
    
    private static func getSupportedLocales() -> [LocaleType] {
        LocaleType.allCases
    }
    
    private func handleLocaleChange() {
        guard AppStorage.shared.appLocale != currentLocale else { return }
        
        updateBundle()
        AppStorage.shared.appLocale = currentLocale
        
        DispatchQueue.main.async { [weak self] in
            self?.objectWillChange.send()
            NotificationCenter.default.post(name: Self.localeDidChangeNotification, object: nil)
        }
    }
    
    private func updateBundle() {
        guard
            let path = Bundle.main.path(forResource: currentLocale.asString, ofType: "lproj"),
            let bundle = Bundle(path: path)
        else {
            self.bundle = Bundle.main
            return
        }
        
        self.bundle = bundle
    }
}
