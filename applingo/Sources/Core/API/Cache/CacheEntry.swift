import Foundation

struct CategoryCacheEntry<T> {
    let value: T
    let timestamp: Date
    let ttl: TimeInterval
    
    var isValid: Bool {
        Date().timeIntervalSince(timestamp) < ttl
    }
}

struct DictionaryCacheEntry {
    let request: ApiDictionaryQueryRequestModel?
    let items: [DatabaseModelDictionary]
    let lastEvaluated: String?
    let ttl: TimeInterval
    let timestamp: Date
    
    var isValid: Bool {
        Date().timeIntervalSince(timestamp) < ttl
    }
}
