import Foundation

final class AppStorage {
    static let shared = AppStorage()
    
    private let permanent: AbstractStorage
    private let temporary: AbstractStorage
    private let cloud: AbstractStorage
    
    /// Private initializer for singleton pattern.
    /// - Parameters:
    ///   - permanent: Persistent storage (default: `UserDefaultsStorage`).
    ///   - cloud: Cloud storage for synced user data (default: `CloudKitStorage`).
    ///   - temporary: Temporary storage (default: `MemoryStorage`).
    private init(
        permanent: AbstractStorage = UserDefaultsStorage(),
        temporary: AbstractStorage = MemoryStorage(),
        cloud: AbstractStorage = CloudKitStorage()
    ) {
        self.permanent = permanent
        self.temporary = temporary
        self.cloud = cloud
        
        evaluateCloudAvailability()
    }
    
    // Check CloudKit.
    func evaluateCloudAvailability() {
        let available = FileManager.default.ubiquityIdentityToken != nil
        useCloud = available
        
        Logger.debug(
            "[AppStorage] Cloud availability",
            metadata: [
                "status": available
            ]
        )
    }
    
    // Sync cloud data.
    func syncAllCloudData() async {
        guard useCloud else {
            Logger.debug("[AppStorage] Cloud sync skipped — useCloud is false")
            return
        }

        guard let cloudStorage = cloud as? CloudKitStorage else {
            Logger.debug("[AppStorage] Cloud sync skipped — cloud storage is not CloudKitStorage")
            return
        }
        
        let cloudKit = cloudStorage.cloud
        
        guard cloudKit.checkCloudAvailability() else {
            Logger.debug("[AppStorage] Cloud sync skipped — cloud is not available")
            return
        }

        let cloudPreferredKeys = [
            "user_score_total",
            "user_level",
            "user_xp"
        ]

        for key in cloudPreferredKeys {
            let value = await cloudStorage.getValueAsync(for: key)
            if !value.isEmpty {
                permanent.setValue(value, for: key)
                Logger.debug(
                    "[AppStorage] Synced cloud → local (async)",
                    metadata: [
                        "key": key,
                        "value": value
                    ]
                )
            }
        }

        let localPreferredKeys = [
            "user_name"
        ]

        for key in localPreferredKeys {
            let value = permanent.getValue(for: key)
            if !value.isEmpty {
                let success = await cloudKit.saveValue(value, for: key)
                Logger.debug(
                    "[AppStorage] Synced local → cloud (local preferred)",
                    metadata: [
                        "key": key,
                        "value": value,
                        "success": success
                    ]
                )
                
                if !success {
                    cloudStorage.addPendingOperation(
                        type: CloudPendingOperationType.save,
                        key: key,
                        value: value
                    )
                }
            }
        }
    }

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
    
    // MARK: - System Params (Permanent Storage)
    
    /// The application's current theme.
    var appTheme: ThemeType {
        get { ThemeType.fromString(permanent.getValue(for: "theme")) }
        set { permanent.setValue(newValue.asString, for: "theme") }
    }
    
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
    
    /// Whether the application is configured to send logs.
    var noLogs: Bool {
        get { temporary.getValue(for: "no_logs") == "true" }
        set { temporary.setValue(String(newValue), for: "no_logs")}
    }

    // MARK: - User Profile (Cloud Storage)
    
    /// The current level of the user.
    var userLevel: Int {
        get { Int(cloud.getValue(for: "user_level")) ?? 1 }
        set { cloud.setValue(String(newValue), for: "user_level") }
    }

    /// The total XP accumulated by the user.
    var userXP: Int {
        get { Int(cloud.getValue(for: "user_xp")) ?? 0 }
        set { cloud.setValue(String(newValue), for: "user_xp") }
    }

    /// The user's display name.
    var userName: String {
        get { cloud.getValue(for: "user_name") }
        set { cloud.setValue(newValue, for: "user_name") }
    }
    
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
    
    /// Whether the app should avoid recording audio.
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
    
    /// Whether the application is allowed to use iCloud (CloudKit).
    var useCloud: Bool {
        get { permanent.getValue(for: "use_cloud") == "true" }
        set { permanent.setValue(String(newValue), for: "use_cloud") }
    }
}
