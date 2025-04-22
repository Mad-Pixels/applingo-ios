import Foundation

/// A singleton class responsible for caching API data for categories and dictionaries.
final class ApiManagerCache {
    // MARK: - Constants
    
    /// Constants for managing cache behavior and logging.
    private enum Constants {
        /// Time-to-live (TTL) for cached categories, in seconds.
        static let categoriesTTL: TimeInterval = 1500
        
        /// Time-to-live (TTL) for cached dictionaries, in seconds.
        static let dictionariesTTL: TimeInterval = 900
    }
    
    // MARK: - Properties
    
    /// Shared singleton instance of `ApiManagerCache`.
    static let shared = ApiManagerCache()
    
    /// API request manager used for fetching data.
    private let request: ApiManagerRequest
    
    /// Cached categories with their metadata (e.g., TTL and timestamp).
    private var categoriesCache: CategoryCacheEntry<ApiModelCategoryItem>?
    
    /// Cached dictionaries with their metadata and associated request parameters.
    private var dictionariesCache: [DictionaryCacheEntry] = []
    
    // MARK: - Initialization
    
    /// Private initializer to enforce singleton usage.
    /// - Parameter request: API request manager for making API calls. Defaults to a new instance of `ApiManagerRequest`.
    private init(request: ApiManagerRequest = ApiManagerRequest()) {
        self.request = request
        Logger.debug(
            "[Cache]: initialized singleton instance"
        )
    }
    
    // MARK: - Public Methods
    
    /// Fetches categories, either from cache or the API.
    /// - Returns: A `ApiModelCategoryItem` containing the fetched categories.
    /// - Throws: An error if the API request fails.
    func getCategories() async throws -> ApiModelCategoryItem {
        if let cache = categoriesCache, cache.isValid {
            Logger.debug(
                "[Cache]: getCategories - returned from cache"
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
            "[Cache]: getCategories - fetched from API"
        )
        return categories
    }
    
    /// Fetches dictionaries, either from cache or the API.
    /// - Parameter request: A request model containing optional query parameters. Defaults to `nil`.
    /// - Returns: A tuple containing the fetched dictionaries and the `lastEvaluated` value (if any).
    /// - Throws: An error if the API request fails.
    func getDictionaries(
        request: ApiModelDictionaryQueryRequest? = nil
    ) async throws -> (
        dictionaries: [ApiModelDictionaryItem],
        lastEvaluated: String?
    ) {
        if let cache = findValidDictionaryCacheEntry(for: request) {
            Logger.debug(
                "[Cache]: getDictionaries - returned from cache",
                metadata: [
                    "request": String(describing: request),
                    "cachedItems": cache.items.count
                ]
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
            "[Cache]: getDictionaries - fetched from API",
            metadata: [
                "request": String(describing: request),
                "fetchedItems": dictionaries.count
            ]
        )
        return (dictionaries: dictionaries, lastEvaluated: lastEvaluated)
    }
    
    /// Downloads a dictionary from the API.
    /// - Parameter dictionary: The dictionary to download.
    /// - Returns: A URL pointing to the downloaded dictionary file.
    /// - Throws: An error if the download fails.
    func downloadDictionary(_ dictionary: ApiModelDictionaryItem) async throws -> URL {
        Logger.debug(
            "[Cache]: downloadDictionary - downloading",
            metadata: ["dictionary": dictionary.name]
        )
        return try await request.downloadDictionary(dictionary)
    }
    
    /// Clears all cached categories and dictionaries.
    func clearCache() {
        dictionariesCache.removeAll()
        categoriesCache = nil
        
        Logger.debug(
            "[Cache]: cache cleared"
        )
    }
    
    // MARK: - Private Methods
    
    /// Finds a valid cache entry for the given dictionary query request.
    /// - Parameter request: The query request model.
    /// - Returns: A valid `DictionaryCacheEntry` if one exists, otherwise `nil`.
    private func findValidDictionaryCacheEntry(
        for request: ApiModelDictionaryQueryRequest?
    ) -> DictionaryCacheEntry? {
        dictionariesCache.first { $0.isValid && $0.request == request }
    }
    
    /// Updates the dictionaries cache with new data.
    /// - Parameters:
    ///   - dictionaries: The fetched dictionaries to cache.
    ///   - lastEvaluated: The `lastEvaluated` value from the API response.
    ///   - request: The request parameters used to fetch the dictionaries.
    private func updateDictionariesCache(
        dictionaries: [ApiModelDictionaryItem],
        lastEvaluated: String?,
        request: ApiModelDictionaryQueryRequest?
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
        
        Logger.debug(
            "[Cache]: updated dictionaries cache",
            metadata: [
                "request": String(describing: request),
                "cachedItems": dictionaries.count
            ]
        )
    }
}
