import Foundation

final internal class TaskStorage {
    private let storage = AppStorage.shared.temporary
    private let storageKey = "tasks"
    
    private var internalMap: [String: String] = [:]
    
    init() {
        loadFromStorage()
    }
    
    func add(_ task: any AbstractTask) {
        if let json = encodeTask(task) {
            internalMap[task.id] = json
            persist()
        }
    }
    
    func del(id: String) {
        internalMap.removeValue(forKey: id)
        persist()
    }
    
    func all() -> [any AbstractTask] {
        internalMap.compactMap { (_, json) in decodeTask(from: json) }
    }
    
    func clear() {
        internalMap.removeAll()
        persist()
    }
    
    private func loadFromStorage() {
        let raw = storage.getValue(for: storageKey)
        if let data = raw.data(using: .utf8),
            let decoded = try? JSONDecoder().decode([String: String].self, from: data) {
            internalMap = decoded
        }
    }
    
    private func persist() {
        if let data = try? JSONEncoder().encode(internalMap),
            let json = String(data: data, encoding: .utf8) {
            storage.setValue(json, for: storageKey)
        }
    }
    
    private func encodeTask(_ task: any AbstractTask) -> String? {
        let wrapper = AnyEncodableTask(task)
        if let data = try? JSONEncoder().encode(wrapper) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
    
    private func decodeTask(from json: String) -> (any AbstractTask)? {
        guard let data = json.data(using: .utf8),
              let wrapper = try? JSONDecoder().decode(AnyEncodableTask.self, from: data) else {
            return nil
        }
        return wrapper.task
    }
}
