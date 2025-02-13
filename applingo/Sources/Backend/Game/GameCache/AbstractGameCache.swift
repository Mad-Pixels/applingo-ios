import Foundation

// MARK: - AbstractGameCache

/// A protocol representing a generic game cache.
/// Conforming types must provide mechanisms to retrieve, remove, initialize, and clear cached items.
protocol AbstractGameCache {
    associatedtype CacheItem
    associatedtype CardItem

    // MARK: - Properties
    var cache: [CacheItem] { get }
    var isLoadingCache: Bool { get }

    // MARK: - Methods
    /// Retrieves a specified number of items from the cache.
    /// - Parameter count: The number of items requested.
    /// - Returns: An array of CacheItem if sufficient items exist, otherwise nil.
    func getItemsFromCache(_ count: Int) -> [CacheItem]?

    /// Removes a specified item from the cache.
    /// - Parameter item: The cache item to be removed.
    func removeItem(_ item: CacheItem)

    /// Initiates the cache (e.g., fetches data).
    func initializeCache()

    /// Clears all items from the cache.
    func clearCache()
}
