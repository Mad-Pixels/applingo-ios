import Foundation

struct UserDefaultsStorage: AbstractStorage {
    /// Retrieves a value for a given key from `UserDefaults`.
    /// - Parameter key: The key to retrieve the value for.
    /// - Returns: The value associated with the key, or an empty string if not found.
    func getValue(for key: String) -> String {
        let value = UserDefaults.standard.string(forKey: key) ?? ""
        
        Logger.debug(
            "[Storage] Retrieved value from UserDefaults",
            metadata: ["key": key, "value": value]
        )
        return value
    }
    
    /// Stores a value for a given key in `UserDefaults`.
    /// - Parameters:
    ///   - value: The value to store.
    ///   - key: The key to associate the value with.
    func setValue(_ value: String, for key: String) {
        UserDefaults.standard.set(value, forKey: key)
        
        Logger.debug(
            "[Storage] Stored value in UserDefaults",
            metadata: ["key": key, "value": value]
        )
    }
}
