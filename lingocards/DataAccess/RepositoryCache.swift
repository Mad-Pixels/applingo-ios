import Foundation

private struct CacheEntry<T> {
    let value: T
    let timestamp: Date
    let ttl: TimeInterval
    
    var isValid: Bool {
        Date().timeIntervalSince(timestamp) < ttl
    }
}

private struct DictionaryCacheEntry {
    let items: [DictionaryItemModel]
    let lastEvaluated: String?
    let request: ApiDictionaryQueryRequestModel?
    let timestamp: Date
    let ttl: TimeInterval
    
    var isValid: Bool {
        Date().timeIntervalSince(timestamp) < ttl
    }
}

final class RepositoryCache: ApiRepositoryProtocol {
    static let shared = RepositoryCache()
    
    private let categoriesTTL: TimeInterval = 1500 // 25 minutes
    private let dictionariesTTL: TimeInterval = 900 // 15 minutes
    
    private var categoriesCache: CacheEntry<CategoryItemModel>?
    private var dictionariesCache: [DictionaryCacheEntry] = []
    
    private let repository: RepositoryAPI
    
    private init(repository: RepositoryAPI = RepositoryAPI()) {
        self.repository = repository
        Logger.debug("[RepositoryCache]: initialized singleton instance")
    }
    
    func getCategories() async throws -> CategoryItemModel {
        if let cache = categoriesCache, cache.isValid {
            Logger.debug("[RepositoryCache]: getCategories - returned from cache")
            return cache.value
        }
        
        let categories = try await repository.getCategories()
        
        let entry = CacheEntry(
            value: categories,
            timestamp: Date(),
            ttl: categoriesTTL
        )
        categoriesCache = entry
        
        Logger.debug("[RepositoryCache]: getCategories - fetched from API")
        return categories
    }
    
    func getDictionaries(request: ApiDictionaryQueryRequestModel? = nil) async throws -> (dictionaries: [DictionaryItemModel], lastEvaluated: String?) {
        if let cacheEntry = findValidDictionaryCacheEntry(for: request) {
            Logger.debug("[RepositoryCache]: getDictionaries - returned from cache for request: \(String(describing: request))")
            return (dictionaries: cacheEntry.items, lastEvaluated: cacheEntry.lastEvaluated)
        }
        
        let (dictionaries, lastEvaluated) = try await repository.getDictionaries(request: request)
        
        let entry = DictionaryCacheEntry(
            items: dictionaries,
            lastEvaluated: lastEvaluated,
            request: request,
            timestamp: Date(),
            ttl: dictionariesTTL
        )
        
        dictionariesCache.removeAll { $0.request == request }
        dictionariesCache.append(entry)
        
        Logger.debug("[RepositoryCache]: getDictionaries - fetched from API for request: \(String(describing: request))")
        return (dictionaries: dictionaries, lastEvaluated: lastEvaluated)
    }
    
    func downloadDictionary(_ dictionary: DictionaryItemModel) async throws -> URL {
        return try await repository.downloadDictionary(dictionary)
    }
    
    func clearCache() {
        categoriesCache = nil
        dictionariesCache.removeAll()
        Logger.debug("[RepositoryCache]: cache cleared")
    }
    
    private func findValidDictionaryCacheEntry(for request: ApiDictionaryQueryRequestModel?) -> DictionaryCacheEntry? {
        return dictionariesCache.first { entry in
            entry.isValid && entry.request == request
        }
    }
}
