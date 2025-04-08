import SwiftUI

class GameSettings: ObservableObject {
    private var settings: [String: any GameSetting] = [:]
    private var order: [String] = []
    
    /// Initializes the container with a predefined list of settings.
    /// - Parameter settings: An array of `GameSetting`-conforming objects.
    init(settings: [any GameSetting] = []) {
        for setting in settings {
            add(setting)
        }
    }
    
    /// Adds a new setting to the collection.
    /// - Parameter setting: The setting to add.
    func add(_ setting: any GameSetting) {
        settings[setting.id] = setting
        order.append(setting.id)
    }
    
    /// Retrieves a setting by its ID.
    /// - Parameter id: The ID of the setting to retrieve.
    /// - Returns: The setting if found, or `nil` otherwise.
    func getSetting(id: String) -> (any GameSetting)? {
        return settings[id]
    }
    
    /// Retrieves the value of a setting by its ID.
    /// - Parameter id: The ID of the setting.
    /// - Returns: The value of the setting if it exists, or `nil` otherwise.
    func getValue(id: String) -> Any? {
        return settings[id]?.getValue()
    }
    
    /// Sets the value of a setting by its ID.
    /// - Parameters:
    ///   - id: The ID of the setting to update.
    ///   - value: The new value to assign.
    /// - Returns: `true` if the setting was updated, `false` otherwise.
    @discardableResult
    func setValue(id: String, value: Any) -> Bool {
        guard let setting = settings[id] else { return false }
        setting.setValue(value)
        return true
    }
    
    /// Returns all settings in the order they were added.
    /// - Returns: An array of settings.
    func getAllSettings() -> [any GameSetting] {
        return order.compactMap { settings[$0] }
    }
    
    /// Indicates whether any settings are stored.
    var hasSettings: Bool {
        return !settings.isEmpty
    }
}
