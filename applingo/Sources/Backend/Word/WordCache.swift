import Foundation
import Combine

/// A class responsible for managing a cache of database words with automatic refilling capabilities.
/// This class implements a thread-safe caching mechanism with validation and automatic cache maintenance.
final class WordCache: ProcessDatabase {
    // MARK: - Public Properties
    
    /// The current state of the cache, published for observation
    @Published private(set) var cache: [DatabaseModelWord] = []
    
    /// Indicates whether the cache is currently loading data
    @Published private(set) var isLoadingCache = false
    
    // MARK: - Private Properties
    
    private let wordRepository: DatabaseManagerWord
    private let queue: DispatchQueue
    private let cacheThreshold: Int
    private let cacheSize: Int
    
    private var cancellables = Set<AnyCancellable>()
    private var cancellationToken = UUID()
    private var frame: ScreenType = .Home
    
    // MARK: - Initialization
    
    /// Initializes the WordCache with custom cache parameters
    /// - Parameters:
    ///   - cacheSize: The maximum number of items to store in cache
    ///   - threshold: The minimum number of items before refilling
    init(cacheSize: Int = 100, threshold: Int = 20) {
        if cacheSize <= 0 {
            Logger.error("[Word]: Invalid cache size", metadata: ["size": String(cacheSize)])
            fatalError("Invalid cache size")
        }
        
        if threshold <= 0 || threshold >= cacheSize {
            Logger.error("[Word]: Invalid threshold", metadata: [
                "threshold": String(threshold),
                "cacheSize": String(cacheSize)
            ])
            fatalError("Invalid threshold")
        }
        
        guard let dbQueue = AppDatabase.shared.databaseQueue else {
            Logger.error("[Word]: Database not connected")
            fatalError("Database is not connected")
        }
        
        self.queue = DispatchQueue(label: "com.applingo.wordcache", attributes: .concurrent)
        self.wordRepository = DatabaseManagerWord(dbQueue: dbQueue)
        self.cacheThreshold = threshold
        self.cacheSize = cacheSize
        
        super.init()
            
        Logger.info("[Word]: Initializing", metadata: [
            "cacheSize": String(cacheSize),
            "threshold": String(threshold)
        ])
            
        setupCacheObserver()
    }
    
    // MARK: - Public Methods
    
    /// Sets the current frame type for tracking context in operations
    /// - Parameter newFrame: The new frame type to set
    func setFrame(_ newFrame: ScreenType) {
        Logger.debug("[Word]: Setting frame", metadata: [
            "oldFrame": frame.rawValue,
            "newFrame": newFrame.rawValue
        ])
        self.frame = newFrame
    }
    
    /// Initializes the cache with initial data
    func initializeCache() {
        Logger.debug("[Word]: Starting cache initialization")
        
        queue.async { [weak self] in
            guard let self = self else {
                Logger.warning("[Word]: Self was deallocated during initialization")
                return
            }
            
            var shouldLoad = false
            self.queue.sync(flags: .barrier) {
                if !self.isLoadingCache {
                    self.isLoadingCache = true
                    shouldLoad = true
                }
            }
            
            guard shouldLoad else {
                Logger.debug("[Word]: Cache is already loading, skipping initialization")
                return
            }
            
            let currentToken = self.cancellationToken
            
            self.performDatabaseOperation(
                { try self.wordRepository.fetchCache(count: self.cacheSize) },
                success: { [weak self] fetchedWords in
                    guard let self = self, currentToken == self.cancellationToken else {
                        Logger.debug("[Word]: Cache operation cancelled or self deallocated")
                        return
                    }
                    
                    self.queue.async(flags: .barrier) {
                        if fetchedWords.isEmpty {
                            Logger.info("[Word]: Cache no words fetched during initialization")
                            self.isLoadingCache = false
                            return
                        }
                        
                        let uniqueWords = self.validateAndFilterWords(fetchedWords)
                        self.cache = uniqueWords
                        Logger.info("[Word]: Cache initialized", metadata: [
                            "wordCount": String(uniqueWords.count)
                        ])
                        self.isLoadingCache = false
                    }
                },
                screen: .WordList,
                metadata: ["operation": "initializeCache", "frameType": frame.rawValue],
                completion: { [weak self] result in
                    guard let self = self, currentToken == self.cancellationToken else { return }
                    
                    if case .failure(let error) = result {
                        Logger.error("[Word]: Cache initialization failed", metadata: [
                            "error": error.localizedDescription
                        ])
                        self.queue.async(flags: .barrier) {
                            self.isLoadingCache = false
                        }
                    }
                }
            )
        }
    }
    
    /// Removes a specific word from the cache
    /// - Parameter item: The word to remove
    func removeFromCache(_ item: DatabaseModelWord) {
        Logger.debug("[Word]: Removing item from cache", metadata: [
            "wordId": item.id.map(String.init) ?? "nil",
            "word": item.frontText
        ])
        queue.async(flags: .barrier) {
            if let itemId = item.id {
                self.cache.removeAll { $0.id == itemId }
            }
        }
    }
    
    /// Clears the entire cache and cancels ongoing operations
    func clearCache() {
        Logger.info("[Word]: Clearing cache", metadata: [
            "cacheSize": String(cache.count)
        ])
        queue.async(flags: .barrier) {
            self.cancellationToken = UUID()
            self.isLoadingCache = false
            self.cache.removeAll()
        }
    }
    
    // MARK: - Private Methods
    
    /// Sets up the cache observer for automatic refilling
    private func setupCacheObserver() {
        Logger.debug("[Word]: Setting up cache observer")
        
        $cache
            .dropFirst()
            .filter { $0.count < self.cacheThreshold }
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .sink { [weak self] cache in
                guard let self = self else { return }
                
                Logger.debug("[Word]: Cache threshold reached", metadata: [
                    "currentCount": String(cache.count),
                    "threshold": String(self.cacheThreshold)
                ])
                if !cache.isEmpty {
                    self.refillCache()
                }
            }
            .store(in: &cancellables)
    }
    
    /// Validates and filters words for uniqueness
    /// - Parameter words: Array of words to validate
    /// - Returns: Array of unique valid words
    private func validateAndFilterWords(_ words: [DatabaseModelWord]) -> [DatabaseModelWord] {
        var uniqueFrontText = Set<String>()
        var uniqueIds = Set<Int>()
        
        return words.filter { word in
            guard !word.frontText.isEmpty else {
                Logger.warning("[Word]: Empty word text found")
                return false
            }
            guard let wordId = word.id else {
                Logger.warning("[Word]: Word without ID found", metadata: [
                    "word": word.frontText
                ])
                return false
            }
            
            let lowercasedText = word.frontText.lowercased()
            let isUnique = uniqueFrontText.insert(lowercasedText).inserted
                && uniqueIds.insert(wordId).inserted
            
            if !isUnique {
                Logger.warning("[Word]: Duplicate word filtered", metadata: [
                    "wordId": String(wordId),
                    "word": word.frontText
                ])
            }
            
            return isUnique
        }
    }
    
    /// Refills the cache when it falls below the threshold
    private func refillCache() {
        queue.async { [weak self] in
            guard let self = self else { return }
            
            var shouldLoad = false
            self.queue.sync(flags: .barrier) {
                if !self.isLoadingCache {
                    self.isLoadingCache = true
                    shouldLoad = true
                }
            }
            
            guard shouldLoad else {
                Logger.debug("[Word]: Refill already in progress")
                return
            }
            
            let needCount = self.cacheSize - self.cache.count
            guard needCount > 0 else {
                Logger.debug("[Word]: No refill needed")
                self.isLoadingCache = false
                return
            }
            
            let currentToken = self.cancellationToken
            let existingIds = Set(self.cache.compactMap { $0.id })
            let existingFrontTexts = Set(self.cache.map { $0.frontText.lowercased() })
            
            Logger.debug("[Word]: Starting cache refill", metadata: [
                "needCount": String(needCount),
                "currentCount": String(self.cache.count)
            ])
            
            self.performDatabaseOperation(
                { try self.wordRepository.fetchCache(count: needCount) },
                success: { [weak self] fetchedWords in
                    guard let self = self, currentToken == self.cancellationToken else { return }
                    
                    self.queue.async(flags: .barrier) {
                        let validatedWords = self.validateAndFilterWords(fetchedWords)
                        let newWords = validatedWords.filter { word in
                            guard let wordId = word.id else { return false }
                            return !existingIds.contains(wordId) &&
                                !existingFrontTexts.contains(word.frontText.lowercased())
                        }
                        
                        if !newWords.isEmpty {
                            let availableSpace = self.cacheSize - self.cache.count
                            if availableSpace > 0 {
                                let wordsToAdd = Array(newWords.prefix(availableSpace))
                                self.cache.append(contentsOf: wordsToAdd)
                                Logger.info("[Word]: Cache refilled", metadata: [
                                    "addedWords": String(wordsToAdd.count),
                                    "totalWords": String(self.cache.count)
                                ])
                            }
                        } else {
                            Logger.warning("[Word]: No new unique words found for refill")
                        }
                        self.isLoadingCache = false
                    }
                },
                screen: .WordList,
                metadata: [
                    "operation": "refillCache",
                    "currentCount": String(self.cache.count),
                    "needCount": String(needCount),
                    "frameType": frame.rawValue
                ],
                completion: { [weak self] result in
                    guard let self = self, currentToken == self.cancellationToken else { return }
                    if case .failure(let error) = result {
                        Logger.error("[Word]: Cache refill failed", metadata: [
                            "error": error.localizedDescription
                        ])
                        self.queue.async(flags: .barrier) {
                            self.isLoadingCache = false
                        }
                    }
                }
            )
        }
    }
    
    deinit {
        Logger.debug("[Word]: Deinitializing")
        clearCache()
    }
}
