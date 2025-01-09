import Foundation

struct UserDefaultsStorage: AbstractStorage {
    func getValue(for key: String) -> String {
        UserDefaults.standard.string(forKey: key) ?? ""
    }
    
    func setValue(_ value: String, for key: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
}
