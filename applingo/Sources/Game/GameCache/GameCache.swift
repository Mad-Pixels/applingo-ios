import Combine

class GameCache<T: Hashable, C>: ObservableObject {
    typealias CacheItem = T
    typealias CardItem = C

    @Published private(set) var cache: [CacheItem] = []
    @Published private(set) var isLoadingCache: Bool = false

    private let wordCache: WordCache
    private var cancellables = Set<AnyCancellable>()

    /// Initializes the GameCache.
    /// - Parameters:
    ///   - cacheSize: The total number of items to cache.
    ///   - threshold: The minimum number of items before triggering a refill.
    init(cacheSize: Int, threshold: Int) {
        self.wordCache = WordCache(cacheSize: cacheSize, threshold: threshold)
        setupObservers()
    }
    
    deinit {
        clear()
    }
    
    /// Must be overridden by subclasses.
    /// - Parameter item: The cache item.
    /// - Returns: A string representing the group key.
    func getGroupKeyImpl(_ item: CacheItem) -> String {
        fatalError("Must be overridden by concrete game")
    }
    
    /// Must be overridden by subclasses.
    /// - Parameters:
    ///   - item: The cache item to validate.
    ///   - selected: An array of already selected cache items.
    /// - Returns: A Boolean indicating whether the item is valid.
    func validateItemImpl(_ item: CacheItem, _ selected: [CacheItem]) -> Bool {
        fatalError("Must be overridden by concrete game")
    }
    
    /// Retrieves a specified number of items from the cache.
    /// - Parameter count: The number of items requested.
    /// - Returns: An array of CacheItem if sufficient items exist, otherwise nil.
    final func getItems(_ count: Int) -> [CacheItem]? {
        guard cache.count >= count else {
            Logger.debug("[GameCache]: Not enough items", metadata: [
                "available": String(cache.count),
                "requested": String(count)
            ])
            wordCache.refillCache()
            return nil
        }
        
        let groupKeyFunction = { [weak self] (item: CacheItem) -> String in
            self?.getGroupKeyImpl(item) ?? ""
        }
        
        let groupedItems = Dictionary(grouping: cache, by: groupKeyFunction)
        
        guard let (subcategory, items) = groupedItems.first(where: { $0.value.count >= count }) else {
            Logger.debug("[GameCache]: No group has enough items")
            wordCache.refillCache()
            return nil
        }
        
        Logger.debug("[GameCache]: Using group", metadata: [
            "subcategory": subcategory,
            "availableWords": String(items.count)
        ])
        
        var selected = Set<CacheItem>()
        let maxAttempts = count * 4
        var attempts = 0
        
        while selected.count < count && attempts < maxAttempts {
            if let item = items.randomElement(),
               validateItemImpl(item, Array(selected)) {
                selected.insert(item)
            }
            attempts += 1
        }
        guard selected.count == count else {
            Logger.debug("[GameCache]: Failed to select required items")
            return nil
        }
        return Array(selected)
    }
    
    /// Removes the specified item from the cache.
    /// - Parameter item: The cache item to be removed.
    final func removeItem(_ item: CacheItem) {
        if let word = item as? DatabaseModelWord {
            wordCache.removeFromCache(word)
        } else {}
    }
    
    /// Initializes the cache by fetching data from the database.
    final func initialize() {
        wordCache.initializeCache()
    }
    
    /// Clears all items from the cache.
    final func clear() {
        wordCache.clearCache()
    }
    
    /// Sets up Combine observers to update the cache and loading state based on the underlying WordCache.
    private func setupObservers() {
        wordCache.$cache
            .sink { [weak self] words in
                self?.cache = words as? [CacheItem] ?? []
            }
            .store(in: &cancellables)
        
        wordCache.$isLoadingCache
            .sink { [weak self] isLoading in
                self?.isLoadingCache = isLoading
            }
            .store(in: &cancellables)
    }
}
