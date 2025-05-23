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
    var noLogs: Bool {
        get { temporary.getValue(for: "no_voice") == "false" }
        set { temporary.setValue(String(newValue), for: "no_logs")}
    }
    
    // MARK: - Active Screen
    /// The currently active screen in the application.
    var activeScreen: ScreenType {
        get { ScreenType(rawValue: temporary.getValue(for: "screen")) ?? .GameMode }
        set { temporary.setValue(newValue.rawValue, for: "screen") }
    }
    
    ///
    // MARK: - Game Lives (Survival Mode)
    var gameLives: Int {
        get {
            Int(temporary.getValue(for: "lives")) ?? DEFAULT_SURVIVAL_LIVES_MIN
        }
        set {
            temporary.setValue(String(newValue), for: "lives")
        }
    }

    // MARK: - Game Duration (Time Mode)
    var gameDuration: TimeInterval {
        get {
            Double(temporary.getValue(for: "game_duration")) ?? DEFAULT_TIME_DURATION_MIN
        }
        set {
            temporary.setValue(String(newValue), for: "game_duration")
        }
    }


    /// Whether the app should avoid using voice features (e.g., TTS).
    var noVoice: Bool {
        get { temporary.getValue(for: "no_voice") == "true" }
        set { temporary.setValue(String(newValue), for: "no_voice")}
    }
    
    /// Whether the app should avoid using voice features (e.g., TTS).
    var noRecord: Bool {
        get { temporary.getValue(for: "no_voice") == "true" }
        set { temporary.setValue(String(newValue), for: "no_voice")}
    }
    
    /// Whether the application is allowed to use ASR (speech recognition).
    var useASR: Bool {
        get { temporary.getValue(for: "use_asr") == "true" }
        set { temporary.setValue(String(newValue), for: "use_asr") }
    }
    
    /// Whether the application is allowed to use Microphone.
    var useMicrophone: Bool {
        get { temporary.getValue(for: "use_microphone") == "true" }
        set { temporary.setValue(String(newValue), for: "use_microphone") }
    }
    
    /// Checks if a specific screen is currently active.
    /// - Parameter screen: The screen to check.
    /// - Returns: `true` if the screen is active, `false` otherwise.
    func isScreenActive(_ screen: ScreenType) -> Bool {
        return activeScreen == screen
    }
}
