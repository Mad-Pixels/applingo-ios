import Foundation

/// Singleton to manage persistent and temporary application storage.
final class AppStorage {
    // MARK: - Singleton Instance
    static let shared = AppStorage()
    
    // MARK: - Properties
    private let permanent: AbstractStorage
    private let temporary: AbstractStorage
    
    // MARK: - Initialization
    /// Private initializer for singleton pattern.
    /// - Parameters:
    ///   - permanent: Persistent storage (default: `UserDefaultsStorage`).
    ///   - temporary: Temporary storage (default: `MemoryStorage`).
    private init(
        permanent: AbstractStorage = UserDefaultsStorage(),
        temporary: AbstractStorage = MemoryStorage()
    ) {
        self.permanent = permanent
        self.temporary = temporary
    }
    
    // MARK: - App Locale
    /// The application's current locale.
    var appLocale: LocaleType {
        get {
            let storedLocale = permanent.getValue(for: "locale")
            if storedLocale.isEmpty {
                let systemLocale: String
                if #available(iOS 16.0, *) {
                    systemLocale = Locale.current.language.languageCode?.identifier ?? "en"
                } else {
                    systemLocale = Locale.current.languageCode ?? "en"
                }
                return LocaleType.fromString(systemLocale)
            }
            return LocaleType.fromString(storedLocale)
        }
        set {
            permanent.setValue(newValue.asString, for: "locale")
        }
    }
    
    // MARK: - App Theme
    /// The application's current theme.
    var appTheme: ThemeType {
        get { ThemeType.fromString(permanent.getValue(for: "theme")) }
        set { permanent.setValue(newValue.asString, for: "theme") }
    }
    
    // MARK: - App ID
    /// A unique identifier for the application instance.
    var appId: String {
        get {
            let id = permanent.getValue(for: "id")
            if id.isEmpty {
                let newId = UUID().uuidString
                permanent.setValue(newId, for: "id")
                return newId
            }
            return id
        }
    }
    
    // MARK: - Log Sending
    /// Whether the application is configured to send logs.
    var sendLogs: Bool {
        get { permanent.getValue(for: "sendLogs") == "true" }
        set { permanent.setValue(String(newValue), for: "sendLogs") }
    }
    
    // MARK: - Active Screen
    /// The currently active screen in the application.
    var activeScreen: ScreenType {
        get { ScreenType(rawValue: temporary.getValue(for: "screen")) ?? .GameMode }
        set { temporary.setValue(newValue.rawValue, for: "screen") }
    }
    
    /// Checks if a specific screen is currently active.
    /// - Parameter screen: The screen to check.
    /// - Returns: `true` if the screen is active, `false` otherwise.
    func isScreenActive(_ screen: ScreenType) -> Bool {
        return activeScreen == screen
    }
}
