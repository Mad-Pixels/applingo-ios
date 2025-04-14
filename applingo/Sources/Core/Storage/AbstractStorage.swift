protocol AbstractStorage {    
    /// Retrieves a value for a given key.
    /// - Parameter key: The key for the value to retrieve.
    /// - Returns: The value as a `String`. Returns an empty string if the key does not exist.
    func getValue(for key: String) -> String
    
    /// Stores a value for a given key.
    /// - Parameters:
    ///   - value: The value to store.
    ///   - key: The key to associate with the value.
    func setValue(_ value: String, for key: String)
}
