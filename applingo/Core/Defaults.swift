import Foundation

struct Defaults {
    enum Keys {
        static let replicaID = "replicaID"
        static let sendLogs = "sendLogs"
        static let language = "language"
        static let theme = "theme"
    }
    
    static var appLanguage: String? {
        get {
            Logger.debug("[Defaults]: Reading app language from UserDefaults")
            return UserDefaults.standard.string(forKey: Keys.language)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.language)
            Logger.debug("[Defaults]: Setting app language to \(newValue ?? "nil") in UserDefaults")
        }
    }
    
    static var appTheme: String? {
        get {
            Logger.debug("[Defaults]: Reading app theme from UserDefaults")
            return UserDefaults.standard.string(forKey: Keys.theme)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.theme)
            Logger.debug("[Defaults]: Setting app theme to \(newValue ?? "nil") in UserDefaults")
        }
    }
    
    static var sendLogs: Bool {
        get {
            let value = UserDefaults.standard.object(forKey: Keys.sendLogs) as? Bool
            Logger.debug("[Defaults]: Reading sendLogs from UserDefaults")
            return value ?? true
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.sendLogs)
            Logger.debug("[Defaults]: Setting sendLogs to \(newValue) in UserDefaults")
        }
    }
    
    static var appReplicaID: String {
        get {
            if let existingID = UserDefaults.standard.string(forKey: Keys.replicaID) {
                Logger.debug("[Defaults]: Reading existing replicaID from UserDefaults")
                return existingID.lowercased()
            } else {
                let newID = UUID().uuidString.lowercased()
                UserDefaults.standard.set(newID, forKey: Keys.replicaID)
                Logger.debug("[Defaults]: Generated and saved new replicaID to UserDefaults")
                return newID
            }
        }
    }
}
