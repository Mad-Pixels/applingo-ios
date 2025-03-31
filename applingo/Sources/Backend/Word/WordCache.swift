import Foundation
import Combine

final class WordCache: ProcessDatabase {
    @Published private(set) var cache: [DatabaseModelWord] = []
    @Published private(set) var isLoadingCache = false

    private let wordRepository: DatabaseManagerWord
    private let queue: DispatchQueue
    private let cacheThreshold: Int
    private let cacheSize: Int
    
    private var cancellables = Set<AnyCancellable>()
    private var cancellationToken = UUID()
    private var inProgressRefill = false
    
    /// Initializes the WordCache.
    /// - Parameters:
    ///   - cacheSize: The total number of words to be cached. Must be greater than zero.
    ///   - threshold: The minimum number of words required before triggering a cache refill.
    ///                Must be greater than zero and less than `cacheSize`.
    init(cacheSize: Int = 10, threshold: Int = 5) {
        Logger.debug("[Word]: WordCache init start", metadata: [
            "cacheSize": String(cacheSize),
            "threshold": String(threshold)
        ])
        
        if cacheSize <= 0 {
            fatalError("Invalid cache size")
        }
        if threshold <= 0 || threshold >= cacheSize {
            fatalError("Invalid threshold")
        }
        
        var adjustedCacheSize = cacheSize
        if adjustedCacheSize <= threshold {
            adjustedCacheSize = threshold + 1
            Logger.debug("[Word]: Adjusted cacheSize", metadata: [
                "original": String(cacheSize),
                "adjusted": String(adjustedCacheSize)
            ])
        }
        
        guard let dbQueue = AppDatabase.shared.databaseQueue else {
            fatalError("Database is not connected")
        }
        
        self.queue = DispatchQueue(label: "com.applingo.wordcache", attributes: .concurrent)
        self.wordRepository = DatabaseManagerWord(dbQueue: dbQueue)
        self.cacheThreshold = threshold
        self.cacheSize = adjustedCacheSize
        
        super.init(dbQueue: dbQueue)
        
        Logger.debug("[Word]: Finished initialization", metadata: [
            "adjustedCacheSize": String(self.cacheSize),
            "cacheThreshold": String(self.cacheThreshold)
        ])
        setupCacheObserver()
    }
    
    deinit {
        Logger.debug("[Word]: Deinitializing cache")
        clearCache()
    }
    
    /// Initializes the word cache by fetching a new set of words from the database.
    ///
    /// This method resets the cache state and sets the loading flag. Once the words are fetched,
    /// the cache is updated accordingly.
    func initializeCache() {
        Logger.debug("[Word]: initializeCache() called")
        
        queue.async(flags: .barrier) { [weak self] in
            guard let self = self else { return }
            
            self.resetCacheState()
            let currentToken = self.cancellationToken
            
            DispatchQueue.main.async {
                self.isLoadingCache = true
            }
            
            self.performDatabaseOperation({
                try self.wordRepository.fetchCache(count: self.cacheSize)
            }, screen: .WordList, metadata: ["operation": "initialize"])
            .sink { [weak self] completion in
                guard let self = self,
                      currentToken == self.cancellationToken else { return }
                
                if case .failure(let error) = completion {
                    Logger.error("[Word]: Initialize failed", metadata: ["error": error.localizedDescription])
                    DispatchQueue.main.async { self.isLoadingCache = false }
                }
            } receiveValue: { [weak self] words in
                guard let self = self,
                      currentToken == self.cancellationToken else { return }
                
                self.processNewWords(words, operation: "initialize")
            }
            .store(in: &self.cancellables)
        }
    }
    
    /// Removes the specified word from the cache.
    /// - Parameter item: The `DatabaseModelWord` item to be removed.
    func removeFromCache(_ item: DatabaseModelWord) {
        Logger.debug("[Word]: removeFromCache() called", metadata: [
            "wordId": item.id.map(String.init) ?? "nil",
            "word": item.frontText
        ])
        
        queue.async(flags: .barrier) { [weak self] in
            guard let self = self,
                  let itemId = item.id else { return }
            
            let beforeCount = self.cache.count
            let newCache = self.cache.filter { $0.id != itemId }
            let afterCount = newCache.count
            
            DispatchQueue.main.async {
                self.cache = newCache
                
                Logger.debug("[Word]: Word removed from cache", metadata: [
                    "beforeCount": String(beforeCount),
                    "afterCount": String(afterCount),
                    "removedWord": item.frontText
                ])
                if afterCount < self.cacheThreshold {
                    self.triggerCacheRefill()
                }
            }
        }
    }
    
    /// Refills the cache by fetching missing words from the database.
    func refillCache() {
        let needCount = cacheSize - cache.count
        guard needCount > 0 else {
            DispatchQueue.main.async { [weak self] in
                self?.isLoadingCache = false
                self?.inProgressRefill = false
            }
            return
        }
        
        Logger.debug("[Word]: Starting cache refill", metadata: [
            "currentCount": String(cache.count),
            "needCount": String(needCount)
        ])
        
        let currentToken = cancellationToken
        let existingIds = Set(cache.compactMap { $0.id })
        let existingFrontTexts = Set(cache.map { $0.frontText.lowercased() })
        
        performDatabaseOperation({
            try self.wordRepository.fetchCache(
                count: needCount,
                excludeIds: Array(existingIds),
                excludeFrontTexts: Array(existingFrontTexts)
            )
        }, screen: .WordList, metadata: ["operation": "refill"])
        .sink(receiveCompletion: { [weak self] completion in
            guard let self = self,
                  currentToken == self.cancellationToken else { return }
            
            if case .failure(let error) = completion {
                Logger.error("[Word]: Refill failed", metadata: ["error": error.localizedDescription])
                DispatchQueue.main.async {
                    self.isLoadingCache = false
                    self.inProgressRefill = false
                }
            }
        }, receiveValue: { [weak self] fetchedWords in
            guard let self = self,
                  currentToken == self.cancellationToken else { return }
            
            self.processNewWords(fetchedWords, operation: "refill")
        })
        .store(in: &cancellables)
    }

    func clearCache() {
        Logger.debug("[Word]: clearCache() called", metadata: ["currentCacheCount": String(cache.count)])
        resetCacheState()
    }
    
    /// Resets the internal cache state, including the cancellation token and refill flag.
    private func resetCacheState() {
        cancellationToken = UUID()
        inProgressRefill = false
        DispatchQueue.main.async {
            self.cache.removeAll()
            self.isLoadingCache = false
        }
    }
    
    /// Sets up a Combine observer to monitor the cache size and trigger a refill when it falls below the threshold.
    private func setupCacheObserver() {
        Logger.debug("[Word]: Setting up cache observer")
        $cache
            .dropFirst()
            .filter { $0.count < self.cacheThreshold }
            .debounce(for: .seconds(0.1), scheduler: DispatchQueue.main)
            .sink { [weak self] currentCache in
                guard let self = self else { return }
                Logger.debug("[Word]: Cache observer triggered", metadata: [
                    "currentCount": String(currentCache.count),
                    "threshold": String(self.cacheThreshold)
                ])
                self.triggerCacheRefill()
            }
            .store(in: &cancellables)
    }
    
    /// Performs the initial load of words into the cache from the database.
    private func performInitialLoad() {
        queue.async { [weak self] in
            guard let self = self else { return }
            
            self.queue.sync(flags: .barrier) {
                self.isLoadingCache = true
            }
            
            let currentToken = self.cancellationToken
            
            self.performDatabaseOperation({
                try self.wordRepository.fetchCache(count: self.cacheSize)
            }, screen: .WordList, metadata: ["operation": "initialLoad"])
            .sink { [weak self] completion in
                guard let self = self,
                      currentToken == self.cancellationToken else { return }
                
                if case .failure(let error) = completion {
                    Logger.error("[Word]: Initial load failed", metadata: ["error": error.localizedDescription])
                    DispatchQueue.main.async {
                        self.isLoadingCache = false
                    }
                }
            } receiveValue: { [weak self] fetchedWords in
                guard let self = self,
                      currentToken == self.cancellationToken else { return }
                
                self.processNewWords(fetchedWords, operation: "initialLoad")
            }
            .store(in: &self.cancellables)
        }
    }
    
    /// Triggers a refill of the cache if no refill operation is already in progress.
    private func triggerCacheRefill() {
        queue.async(flags: .barrier) { [weak self] in
            guard let self = self else { return }
            
            guard !self.inProgressRefill && !self.isLoadingCache else {
                Logger.debug("[Word]: Skipping refill - operation in progress")
                return
            }
            
            self.inProgressRefill = true
            DispatchQueue.main.async { [weak self] in
                self?.isLoadingCache = true
            }
            
            self.performRefill()
        }
    }
    
    /// Performs the refill operation to fetch missing words and update the cache.
    private func performRefill() {
        let needCount = cacheSize - cache.count
        guard needCount > 0 else {
            DispatchQueue.main.async { [weak self] in
                self?.isLoadingCache = false
                self?.inProgressRefill = false
            }
            return
        }
        
        let currentToken = cancellationToken
        let existingIds = Set(cache.compactMap { $0.id })
        let existingFrontTexts = Set(cache.map { $0.frontText.lowercased() })
        
        performDatabaseOperation({
            try self.wordRepository.fetchCache(
                count: needCount,
                excludeIds: Array(existingIds),
                excludeFrontTexts: Array(existingFrontTexts)
            )
        }, screen: .WordList, metadata: ["operation": "refill"])
        .sink { [weak self] completion in
            if case .failure(let error) = completion {
                Logger.error("[Word]: Refill failed", metadata: ["error": error.localizedDescription])
            }
            DispatchQueue.main.async {
                self?.isLoadingCache = false
                self?.inProgressRefill = false
            }
        } receiveValue: { [weak self] words in
            guard let self = self,
                  currentToken == self.cancellationToken else { return }
            self.processNewWords(words, operation: "refill")
        }
        .store(in: &cancellables)
    }
    
    /// Processes the newly fetched words by filtering out duplicates and updating the cache.
    /// - Parameters:
    ///   - words: An array of `DatabaseModelWord` objects fetched from the database.
    ///   - operation: A string identifier for the operation (e.g., "initialize", "refill", "initialLoad").
    private func processNewWords(_ words: [DatabaseModelWord], operation: String) {
        let uniqueWords = validateAndFilterWords(words)
        
        Logger.debug("[Word]: Processing words", metadata: [
            "operation": operation,
            "count": String(uniqueWords.count)
        ])
        
        if !uniqueWords.isEmpty {
            let currentIds = Set(cache.compactMap { $0.id })
            let newWords = uniqueWords.filter { word in
                guard let id = word.id else { return false }
                return !currentIds.contains(id)
            }
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.cache.append(contentsOf: newWords)
                self.inProgressRefill = false
                self.isLoadingCache = false
            }
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.inProgressRefill = false
                self?.isLoadingCache = false
            }
        }
    }
    
    /// Validates and filters the fetched words by removing duplicates based on `frontText` and `id`.
    /// - Parameter words: The array of fetched `DatabaseModelWord` objects.
    /// - Returns: A filtered array containing only unique words.
    private func validateAndFilterWords(_ words: [DatabaseModelWord]) -> [DatabaseModelWord] {
        var uniqueFrontText = Set<String>()
        var uniqueIds = Set<Int>()
        
        return words.filter { word in
            guard !word.frontText.isEmpty,
                  let wordId = word.id else { return false }
            
            let lowercasedText = word.frontText.lowercased()
            let isUnique = uniqueFrontText.insert(lowercasedText).inserted &&
                           uniqueIds.insert(wordId).inserted
            
            if !isUnique {
                Logger.warning("[Word]: Duplicate word filtered", metadata: [
                    "wordId": String(wordId),
                    "word": word.frontText
                ])
            }
            
            return isUnique
        }
    }
}
