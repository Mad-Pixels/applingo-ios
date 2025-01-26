import Foundation

final class ApiManagerCache {
    // MARK: - Constants
    private enum Constants {
        static let dictionariesTTL: TimeInterval = 900
        static let categoriesTTL: TimeInterval = 1500
        static let loggerTag = "[ApiCache]"
    }
   
    // MARK: - Properties
    static let shared = ApiManagerCache()
    private let request: ApiManagerRequest
   
    private var categoriesCache: CategoryCacheEntry<CategoryItemModel>?
    private var dictionariesCache: [DictionaryCacheEntry] = []
   
    // MARK: - Init
    private init(request: ApiManagerRequest = ApiManagerRequest()) {
        self.request = request
        Logger.debug(
            "\(Constants.loggerTag): initialized singleton instance"
        )
    }
   
    // MARK: - Public Methods
    func getCategories() async throws -> CategoryItemModel {
        if let cache = categoriesCache, cache.isValid {
            Logger.debug(
                "\(Constants.loggerTag): getCategories - returned from cache"
            )
            return cache.value
        }
       
        let categories = try await request.getCategories()
        categoriesCache = CategoryCacheEntry(
            value: categories,
            timestamp: Date(),
            ttl: Constants.categoriesTTL
        )
       
        Logger.debug(
            "\(Constants.loggerTag): getCategories - fetched from API"
        )
        return categories
    }
   
    func getDictionaries(
        request: ApiDictionaryQueryRequestModel? = nil
    ) async throws -> (
        dictionaries: [DatabaseModelDictionary],
        lastEvaluated: String?
    ) {
        if let cache = findValidDictionaryCacheEntry(for: request) {
            Logger.debug(
                "\(Constants.loggerTag): getDictionaries - returned from cache"
            )
            return (dictionaries: cache.items, lastEvaluated: cache.lastEvaluated)
        }
       
        let (dictionaries, lastEvaluated) = try await self.request.getDictionaries(request: request)
        updateDictionariesCache(
            dictionaries: dictionaries,
            lastEvaluated: lastEvaluated,
            request: request
        )
       
        Logger.debug(
            "\(Constants.loggerTag): getDictionaries - fetched from API"
        )
        return (dictionaries: dictionaries, lastEvaluated: lastEvaluated)
    }
   
    func downloadDictionary(_ dictionary: DatabaseModelDictionary) async throws -> URL {
        try await request.downloadDictionary(dictionary)
    }
   
    func clearCache() {
        dictionariesCache.removeAll()
        categoriesCache = nil
        
        Logger.debug(
            "\(Constants.loggerTag): cache cleared"
        )
    }
   
    // MARK: - Private Methods
    private func findValidDictionaryCacheEntry(
        for request: ApiDictionaryQueryRequestModel?
    ) -> DictionaryCacheEntry? {
        dictionariesCache.first { $0.isValid && $0.request == request }
    }
   
    private func updateDictionariesCache(
        dictionaries: [DatabaseModelDictionary],
        lastEvaluated: String?,
        request: ApiDictionaryQueryRequestModel?
    ) {
        let entry = DictionaryCacheEntry(
            request: request,
            items: dictionaries,
            lastEvaluated: lastEvaluated,
            ttl: Constants.dictionariesTTL,
            timestamp: Date()
        )
        dictionariesCache.removeAll { $0.request == request }
        dictionariesCache.append(entry)
    }
}
