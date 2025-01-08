import Foundation

struct UserDefaultsStorage: AbstractStorage {
    private enum Keys {
        static let sendLogs = "sendLogs"
        static let language = "language"
        static let theme = "theme"
        static let id = "is"
    }
    
    var appLanguage: String? {
        get {
            Logger.debug("[Storage]: Reading app language from UserDefaults")
            return UserDefaults.standard.string(forKey: Keys.language)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.language)
            Logger.debug("[Storage]: Setting app language to \(newValue ?? "nil")")
        }
    }
    
    var appTheme: String? {
        get {
            Logger.debug("[Storage]: Reading app theme from UserDefaults")
            return UserDefaults.standard.string(forKey: Keys.theme)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.theme)
            Logger.debug("[Storage]: Setting app theme to \(newValue ?? "nil")")
        }
    }
    
    var sendLogs: Bool {
        get {
            let value = UserDefaults.standard.object(forKey: Keys.sendLogs) as? Bool
            Logger.debug("[Storage]: Reading sendLogs")
            return value ?? true
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.sendLogs)
            Logger.debug("[Storage]: Setting sendLogs to \(newValue)")
        }
    }

    var appId: String {
        get {
            if let existingID = UserDefaults.standard.string(forKey: Keys.id) {
                Logger.debug("[Storage]: Reading existing id")
                return existingID.lowercased()
            } else {
                let id = UUID().uuidString.lowercased()
                UserDefaults.standard.set(id, forKey: Keys.id)
                Logger.debug("[Storage]: Generated and saved new id \(id)")
                return id
            }
        }
    }
}
