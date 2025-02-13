import Combine

// MARK: - BaseGameCache

/// A base cache class for game data that supports customizable grouping and validation via closures.
/// This class observes an underlying WordCache and publishes its own cache state.
class BaseGameCache<T: Hashable, C>: AbstractGameCache, ObservableObject {
    typealias CacheItem = T
    typealias CardItem = C
    
    // MARK: - Published Properties
    @Published private(set) var cache: [CacheItem] = []
    @Published private(set) var isLoadingCache: Bool = false
    
    // MARK: - Customization Closures
    private let wordCache: WordCache
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    init(cacheSize: Int, threshold: Int) {
        self.wordCache = WordCache(cacheSize: cacheSize, threshold: threshold)
        setupObservers()
    }
    
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
    
    // MARK: - Public Methods
    func getItemsFromCache(_ count: Int) -> [CacheItem]? {
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
        var attempts = 0
        let maxAttempts = count * 4
        
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
    
    func removeItem(_ item: CacheItem) {
        if let word = item as? DatabaseModelWord {
            wordCache.removeFromCache(word)
        } else {
            Logger.error("[GameCache]: Invalid item type")
        }
    }
    
    func initializeCache() {
        wordCache.initializeCache()
    }
    
    func clearCache() {
        wordCache.clearCache()
    }
    
    // MARK: - Methods to Override
    func getGroupKeyImpl(_ item: CacheItem) -> String {
        fatalError("Must be overridden by concrete game")
    }
    
    func validateItemImpl(_ item: CacheItem, _ selected: [CacheItem]) -> Bool {
        fatalError("Must be overridden by concrete game")
    }
    
    deinit {
        Logger.debug("[GameCache]: Deinitializing")
        clearCache()
    }
}
