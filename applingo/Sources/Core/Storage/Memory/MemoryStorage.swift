final class MemoryStorage: AbstractStorage {
    private var storage: [String: String] = [:]
    
    func getValue(for key: String) -> String {
        storage[key] ?? ""
    }
    
    func setValue(_ value: String, for key: String) {
        storage[key] = value
    }
}
