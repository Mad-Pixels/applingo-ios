import Foundation

/// Manages locale settings and provides localized strings for the app.
final class LocaleManager: ObservableObject {
    // MARK: - Singleton
    
    /// Shared instance of `LocaleManager`.
    static let shared = LocaleManager()
    
    // MARK: - Properties
    
    /// The current locale of the app.
    @Published private(set) var currentLocale: LocaleType {
        didSet {
            Logger.debug(
                "[Locale]: Locale changed",
                metadata: [
                    "oldLocale": oldValue.asString,
                    "newLocale": currentLocale.asString
                ]
            )
            handleLocaleChange()
        }
    }
    
    /// UUID used to force view updates.
    @Published private(set) var viewId = UUID()
    
    /// Notification name for locale changes.
    static let localeDidChangeNotification = Notification.Name("LocaleManagerDidChangeLocale")
    
    /// Supported locales.
    private(set) var supportedLocales: [LocaleType] = []
    
    /// The bundle used for localization.
    private var bundle: Bundle?
    
    // MARK: - Initialization
    
    /// Private initializer to enforce singleton usage.
    private init() {
        self.supportedLocales = Self.getSupportedLocales()
        self.currentLocale = Self.getInitialLocale()
        self.updateBundle()
        
        Logger.debug(
            "[Locale]: Initialized",
            metadata: [
                "currentLocale": currentLocale.asString,
                "supportedLocales": supportedLocales.map { $0.asString }
            ]
        )
    }
    
    // MARK: - Public Methods
    
    /// Sets the locale for the app.
    /// - Parameter locale: The new locale to set.
    func setLocale(_ locale: LocaleType) {
        guard locale != currentLocale else {
            Logger.debug(
                "[Locale]: Attempt to set the same locale",
                metadata: ["locale": locale.asString]
            )
            return
        }
        Logger.debug(
            "[Locale]: Setting new locale",
            metadata: ["locale": locale.asString]
        )
        self.currentLocale = locale
    }
    
    /// Returns a localized string for a given key, with optional arguments for formatting.
    /// - Parameters:
    ///   - key: The localization key.
    ///   - arguments: Formatting arguments for the localized string.
    /// - Returns: A localized and formatted string.
    func localizedString(for key: String, arguments: CVarArg...) -> String {
        let format = bundle?.localizedString(forKey: key, value: nil, table: nil) ?? key
        return String(format: format, arguments: arguments).lowercased()
    }
    
    // MARK: - Private Methods
    
    /// Retrieves the initial locale from `AppStorage`.
    /// - Returns: The initial locale.
    private static func getInitialLocale() -> LocaleType {
        let locale = AppStorage.shared.appLocale
        Logger.debug(
            "[Locale]: Initial locale retrieved",
            metadata: ["locale": locale.asString]
        )
        return locale
    }
    
    /// Retrieves all supported locales.
    /// - Returns: An array of supported `LocaleType`.
    private static func getSupportedLocales() -> [LocaleType] {
        let locales = LocaleType.allCases
        Logger.debug(
            "[Locale]: Supported locales",
            metadata: ["locales": locales.map { $0.asString }]
        )
        return locales
    }
    
    /// Handles changes to the locale.
    private func handleLocaleChange() {
        guard AppStorage.shared.appLocale != currentLocale else { return }
        
        Logger.debug(
            "[Locale]: Handling locale change",
            metadata: ["newLocale": currentLocale.asString]
        )
        
        updateBundle()
        AppStorage.shared.appLocale = currentLocale
        
        DispatchQueue.main.async { [weak self] in
            self?.objectWillChange.send()
            NotificationCenter.default.post(name: Self.localeDidChangeNotification, object: nil)
        }
    }
    
    /// Updates the localization bundle based on the current locale.
    private func updateBundle() {
        if let path = Bundle.main.path(forResource: currentLocale.asString, ofType: "lproj"),
           let bundle = Bundle(path: path) {
            self.bundle = bundle
            Logger.debug(
                "[Locale]: Bundle updated",
                metadata: ["locale": currentLocale.asString, "bundlePath": path]
            )
        } else {
            self.bundle = Bundle.main
            Logger.debug(
                "[Locale]: Default bundle used",
                metadata: ["locale": currentLocale.asString]
            )
        }
    }
}
