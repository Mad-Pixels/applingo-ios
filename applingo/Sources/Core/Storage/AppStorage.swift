import Foundation
import CloudKit

final class AppStorage {
    static let shared = AppStorage()
    
    private let permanent: AbstractStorage
    private let temporary: AbstractStorage
    
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
    
    // MARK: - System Params (Permanent Storage)
    
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
    
    /// The application's current theme.
    var appTheme: ThemeType {
        get { ThemeType.fromString(permanent.getValue(for: "theme")) }
        set { permanent.setValue(newValue.asString, for: "theme") }
    }
    
    /// A unique identifier for the application instance.
    var appId: String {
        let savedId = permanent.getValue(for: "id")
        if !savedId.isEmpty {
            return savedId
        }

        var result: String?
        let semaphore = DispatchSemaphore(value: 0)

        CKContainer.default().fetchUserRecordID { recordID, error in
            if let recordID = recordID {
                result = recordID.recordName
            }
            semaphore.signal()
        }

        _ = semaphore.wait(timeout: .now() + 2)

        if let cloudID = result {
            permanent.setValue(cloudID, for: "id")
            return cloudID
        }

        let fallbackId = UUID().uuidString
        permanent.setValue(fallbackId, for: "id")
        return fallbackId
    }
    
    /// Whether the application is configured to send logs.
    var noLogs: Bool {
        get { temporary.getValue(for: "no_logs") == "false" }
        set { temporary.setValue(String(newValue), for: "no_logs")}
    }
    
    /// First app launch flag.
    
    
    // MARK: - App Session Params (Temporary Storage)
    
    /// Checks if a specific screen is currently active.
    /// - Parameter screen: The screen to check.
    /// - Returns: `true` if the screen is active, `false` otherwise.
    func isScreenActive(_ screen: ScreenType) -> Bool {
        return activeScreen == screen
    }
    
    /// The currently active screen in the application.
    var activeScreen: ScreenType {
        get { ScreenType(rawValue: temporary.getValue(for: "screen")) ?? .GameMode }
        set { temporary.setValue(newValue.rawValue, for: "screen") }
    }
    
    /// The currently active Game Lives count (Survival Mode)
    var gameLives: Int {
        get {
            Int(temporary.getValue(for: "lives")) ?? DEFAULT_SURVIVAL_LIVES
        }
        set {
            temporary.setValue(String(newValue), for: "lives")
        }
    }

    /// The currently active Game Duration (Time Mode)
    var gameDuration: Int {
        get {
            Int(temporary.getValue(for: "game_duration")) ?? DEFAULT_TIME_DURATION
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
    
    /// First app launch flag.
    var firstFlight: Bool {
        get { temporary.getValue(for: "first_flight") == "true" }
        set { temporary.setValue(String(newValue), for: "first_flight")}
    }
    
    /// Whether the app should avoid using voice features (e.g., TTS).
    var noRecord: Bool {
        get { temporary.getValue(for: "no_record") == "true" }
        set { temporary.setValue(String(newValue), for: "no_record")}
    }
    
    // MARK: - Permission Params (Temporary Storage)
    
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
}
