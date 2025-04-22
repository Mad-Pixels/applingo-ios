import Foundation

final class MemoryStorage: AbstractStorage {
    /// Dictionary to store key-value pairs in memory.
    private var storage: [String: String] = [:]
        
    /// Retrieves a value for a given key from memory storage.
    /// - Parameter key: The key to retrieve the value for.
    /// - Returns: The value associated with the key, or an empty string if not found.
    func getValue(for key: String) -> String {
        let value = storage[key] ?? ""
        Logger.debug(
            "[Storage] Retrieved value from MemoryStorage",
            metadata: ["key": key, "value": value]
        )
        return value
    }
    
    /// Stores a value for a given key in memory storage.
    /// - Parameters:
    ///   - value: The value to store.
    ///   - key: The key to associate the value with.
    func setValue(_ value: String, for key: String) {
        storage[key] = value
        Logger.debug(
            "[Storage] Stored value in MemoryStorage",
            metadata: ["key": key, "value": value]
        )
    }
}
