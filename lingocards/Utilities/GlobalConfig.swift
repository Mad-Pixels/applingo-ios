import SwiftUI

enum Configuration {
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
    
    static var apiURL: String {
        guard
            let api = config["API"] as? [String: Any],
            let url = api["URL"] as? String
        else {
            fatalError("API URL not configured")
        }
        return url
    }
    
    static var apiToken: String {
        guard
            let api = config["API"] as? [String: Any],
            let token = api["Token"] as? String
        else {
            fatalError("API token not configured")
        }
        return token
    }
}
