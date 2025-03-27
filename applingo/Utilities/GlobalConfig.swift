import SwiftUI

/// Global configuration loaded from Configuration.plist.
enum GlobalConfig {
    /// Dictionary loaded from the Configuration.plist file.
    private static let config: [String: Any] = {
        guard
            let url = Bundle.main.url(forResource: "Configuration", withExtension: "plist"),
            let data = try? Data(contentsOf: url),
            let dict = try? PropertyListSerialization.propertyList(from: data, format: nil) as? [String: Any]
        else {
            fatalError("Configuration.plist not found or invalid")
        }
        return dict
    }()
    
    /// The API base URL configured in Configuration.plist.
    static var apiURL: String {
        guard
            let api = config["API"] as? [String: Any],
            let url = api["URL"] as? String
        else {
            fatalError("API URL not configured")
        }
        return url
    }
    
    /// The API token configured in Configuration.plist.
    static var apiToken: String {
        guard
            let api = config["API"] as? [String: Any],
            let token = api["Token"] as? String
        else {
            fatalError("API token not configured")
        }
        return token
    }
    
    /// The database file name configured in Configuration.plist.
    static var dbFile: String {
        guard
            let db = config["DB"] as? [String: Any],
            let file = db["File"] as? String
        else {
            fatalError("DB File not configured")
        }
        return file
    }
}
