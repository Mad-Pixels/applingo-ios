import SwiftUI
import Combine

class GameCache<T: Hashable>: ObservableObject {
    typealias CacheItem = T

    @Published private(set) var cache: [CacheItem] = []
    @Published private(set) var isLoadingCache: Bool = false

    private let refillCooldownInterval: TimeInterval = 1.0
    private let wordCache: WordCache
    
    private var cancellables = Set<AnyCancellable>()
    private var refillCooldown: Timer?
    private var canRefill: Bool = true

    /// Initializes the GameCache.
    /// - Parameters:
    ///   - cacheSize: The total number of items to cache.
    ///   - threshold: The minimum number of items before triggering a refill.
    init(cacheSize: Int, threshold: Int) {
        self.wordCache = WordCache(cacheSize: cacheSize, threshold: threshold)
        setupObservers()
    }
    
    deinit {
        refillCooldown?.invalidate()
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
            requestRefill()
            return nil
        }

        let groupKeyFunction = { [weak self] (item: CacheItem) -> String in
            self?.getGroupKeyImpl(item) ?? ""
        }

        let allGrouped = Dictionary(grouping: cache, by: groupKeyFunction)
        let allKeys = allGrouped.keys

        let groupedItems: [String: [CacheItem]]
        
        if allKeys.allSatisfy({ $0.isEmpty }) {
            groupedItems = allGrouped
        } else {
            groupedItems = allGrouped.filter { !$0.key.isEmpty }
        }

        guard let (subcategory, items) = groupedItems.first(where: { $0.value.count >= count }) else {
            Logger.debug("[GameCache]: No group has enough items")
            requestRefill()
            return nil
        }

        Logger.debug("[GameCache]: Using group", metadata: [
            "subcategory": subcategory,
            "availableWords": String(items.count)
        ])

        var availableItems = Set(items)
        var selected = [CacheItem]()
        let maxAttempts = count * 4
        var attempts = 0

        while selected.count < count && attempts < maxAttempts && !availableItems.isEmpty {
            guard let item = availableItems.randomElement() else { break }

            if validateItemImpl(item, selected) {
                selected.append(item)
            }
            availableItems.remove(item)
            attempts += 1
        }

        guard selected.count == count else {
            Logger.debug("[GameCache]: Failed to select required items", metadata: [
                "selected": String(selected.count),
                "required": String(count),
                "attempts": String(attempts)
            ])
            requestRefill()
            return nil
        }

        return selected
    }
    
    /// Removes the specified item from the cache.
    /// - Parameter item: The cache item to be removed.
    final func removeItem(_ item: CacheItem) {
        if let word = item as? DatabaseModelWord {
            wordCache.removeFromCache(word)
        } else {
            Logger.warning("[GameCache]: Attempt to remove non-DatabaseModelWord item", metadata: [
                "itemType": String(describing: type(of: item))
            ])
        }
    }
    
    /// Initializes the cache by fetching data from the database.
    final func initialize() {
        Logger.debug("[GameCache]: Initializing cache")
        wordCache.initializeCache()
    }
    
    /// Clears all items from the cache.
    final func clear() {
        wordCache.clearCache()
    }
    
    /// Adding items to cache.
    private func requestRefill() {
        guard canRefill else {
            Logger.debug("[GameCache]: Refill on cooldown")
            return
        }
        
        canRefill = false
        wordCache.refillCache()
        
        refillCooldown?.invalidate()
        refillCooldown = Timer.scheduledTimer(withTimeInterval: refillCooldownInterval, repeats: false) { [weak self] _ in
            self?.canRefill = true
            Logger.debug("[GameCache]: Refill cooldown expired")
        }
    }
    
    /// Sets up Combine observers to update the cache and loading state based on the underlying WordCache.
    private func setupObservers() {
        wordCache.$cache
            .sink { [weak self] words in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    if let typedWords = words as? [CacheItem] {
                        self.cache = typedWords
                    } else {
                        Logger.warning("[GameCache]: Type mismatch in cache update")
                        self.cache = []
                    }
                }
            }
            .store(in: &cancellables)
        
        wordCache.$isLoadingCache
            .sink { [weak self] isLoading in
                DispatchQueue.main.async {
                    self?.isLoadingCache = isLoading
                }
            }
            .store(in: &cancellables)
    }
}
