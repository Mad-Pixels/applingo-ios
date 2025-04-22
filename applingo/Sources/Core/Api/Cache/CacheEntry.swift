import Foundation

/// Represents a cache entry for a category with a validity check.
struct CategoryCacheEntry<T> {
    /// Cached value of type `T`.
    let value: T
    
    /// Timestamp when the entry was cached.
    let timestamp: Date
    
    /// Time-to-live (TTL) for the cache entry.
    let ttl: TimeInterval
    
    /// Indicates whether the cache entry is still valid based on its TTL.
    var isValid: Bool {
        Date().timeIntervalSince(timestamp) < ttl
    }
}

/// Represents a cache entry for dictionaries with a validity check.
struct DictionaryCacheEntry {
    /// The request model used to fetch the dictionaries, if applicable.
    let request: ApiModelDictionaryQueryRequest?
    
    /// The cached list of dictionaries.
    let items: [ApiModelDictionaryItem]
    
    /// The last evaluated key for pagination purposes.
    let lastEvaluated: String?
    
    /// Time-to-live (TTL) for the cache entry.
    let ttl: TimeInterval
    
    /// Timestamp when the entry was cached.
    let timestamp: Date
    
    /// Indicates whether the cache entry is still valid based on its TTL.
    var isValid: Bool {
        Date().timeIntervalSince(timestamp) < ttl
    }
}
