import SwiftUI

class GameSettings: ObservableObject {
    private var settings: [String: any GameSetting] = [:]
    
    init(settings: [any GameSetting] = []) {
        for setting in settings {
            self.settings[setting.id] = setting
        }
    }
    
    func add(_ setting: any GameSetting) {
        settings[setting.id] = setting
    }
    
    /// Get a setting by ID
    /// - Parameter id: The ID of the setting to retrieve
    /// - Returns: The setting if found, nil otherwise
    func getSetting(id: String) -> (any GameSetting)? {
        return settings[id]
    }
    
    /// Get value of a setting by ID
    /// - Parameter id: The ID of the setting
    /// - Returns: The value if setting exists, nil otherwise
    func getValue(id: String) -> Any? {
        guard let setting = settings[id] else { return nil }
        return setting.getValue()
    }
    
    /// Set value of a setting by ID
    /// - Parameters:
    ///   - id: The ID of the setting
    ///   - value: The new value
    /// - Returns: True if setting was updated, false otherwise
    @discardableResult
    func setValue(id: String, value: Any) -> Bool {
        guard let setting = settings[id] else { return false }
        setting.setValue(value)
        return true
    }
    
    /// Get all settings
    /// - Returns: Array of all settings
    func getAllSettings() -> [any GameSetting] {
        return Array(settings.values)
    }
    
    /// Check if has any settings
    var hasSettings: Bool {
        return !settings.isEmpty
    }
}
