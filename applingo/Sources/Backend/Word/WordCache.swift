import Foundation
import Combine

final class WordCache: ProcessDatabase {
    // MARK: - Public Properties
    @Published private(set) var cache: [DatabaseModelWord] = []
    @Published private(set) var isLoadingCache = false
    
    // MARK: - Private Properties
    private let wordRepository: DatabaseManagerWord
    private let queue: DispatchQueue
    private let cacheThreshold: Int
    private let cacheSize: Int
    
    private var cancellables = Set<AnyCancellable>()
    private var cancellationToken = UUID()
    private var inProgressRefill = false
    
    // MARK: - Initialization
    init(cacheSize: Int = 7, threshold: Int = 6) {
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
    
    // MARK: - Public Methods
    func initializeCache() {
        Logger.debug("[Word]: initializeCache() called")
        
        queue.async(flags: .barrier) { [weak self] in
            guard let self = self else { return }
            
            // Сбрасываем состояние
            self.cancellationToken = UUID()
            self.inProgressRefill = false
            DispatchQueue.main.async {
                self.isLoadingCache = true
                self.cache.removeAll()
            }
            
            let currentToken = self.cancellationToken
            
            Logger.debug("[Word]: Starting initial load", metadata: ["cacheSize": String(self.cacheSize)])
            
            // Загружаем начальные данные
            self.performDatabaseOperation({
                try self.wordRepository.fetchCache(count: self.cacheSize)
            }, screen: .WordList, metadata: ["operation": "initializeCache"])
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
                
                Logger.debug("[Word]: Initial load completed", metadata: ["fetchedCount": String(fetchedWords.count)])
                
                self.queue.async(flags: .barrier) {
                    let uniqueWords = self.validateAndFilterWords(fetchedWords)
                    
                    DispatchQueue.main.async {
                        self.cache = uniqueWords
                        self.isLoadingCache = false
                        
                        Logger.debug("[Word]: Cache initialized", metadata: [
                            "uniqueCount": String(uniqueWords.count),
                            "words": uniqueWords.map { $0.frontText }.joined(separator: ", ")
                        ])
                    }
                }
            }
            .store(in: &self.cancellables)
        }
    }
    
     func removeFromCache(_ item: DatabaseModelWord) {
        Logger.debug("[Word]: removeFromCache() called", metadata: [
            "wordId": item.id.map(String.init) ?? "nil",
            "word": item.frontText
        ])
        
        queue.async(flags: .barrier) { [weak self] in
            guard let self = self,
                  let itemId = item.id else { return }
            
            let beforeCount = self.cache.count
            // Подготавливаем новый массив в бэкграунде
            let newCache = self.cache.filter { $0.id != itemId }
            let afterCount = newCache.count
            
            // Обновляем на главном потоке
            DispatchQueue.main.async {
                self.cache = newCache
                
                Logger.debug("[Word]: Word removed from cache", metadata: [
                    "beforeCount": String(beforeCount),
                    "afterCount": String(afterCount),
                    "removedWord": item.frontText
                ])
                
                // Проверяем необходимость обновления кеша
                if afterCount < self.cacheThreshold {
                    self.triggerCacheRefill()
                }
            }
        }
    }

    
    func clearCache() {
        Logger.debug("[Word]: clearCache() called", metadata: ["currentCacheCount": String(cache.count)])
        resetCacheState()
    }
    
    // MARK: - Private Methods
    private func resetCacheState() {
        queue.async(flags: .barrier) {
            self.cancellationToken = UUID()
            self.inProgressRefill = false
            DispatchQueue.main.async {
                self.isLoadingCache = false
                self.cache.removeAll()
            }
            Logger.debug("[Word]: Cache state reset")
        }
    }
    
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
                    self.isLoadingCache = false
                }
            } receiveValue: { [weak self] fetchedWords in
                guard let self = self,
                      currentToken == self.cancellationToken else { return }
                
                self.processNewWords(fetchedWords, operation: "initialLoad")
            }
            .store(in: &self.cancellables)
        }
    }
    
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
    
    private func performRefill() {
        queue.async(flags: .barrier) { [weak self] in
            guard let self = self else { return }
            
            defer {
                // Гарантируем сброс флага в любом случае
                self.inProgressRefill = false
            }
            
            let needCount = self.cacheSize - self.cache.count
            guard needCount > 0 else {
                Logger.debug("[Word]: No refill needed - cache is full")
                DispatchQueue.main.async {
                    self.isLoadingCache = false
                }
                return
            }
            
            Logger.debug("[Word]: Starting cache refill", metadata: [
                "currentCount": String(self.cache.count),
                "needCount": String(needCount)
            ])
            
            self.inProgressRefill = true
            DispatchQueue.main.async {
                self.isLoadingCache = true
            }
            
            let currentToken = self.cancellationToken
            let existingIds = Set(self.cache.compactMap { $0.id })
            let existingFrontTexts = Set(self.cache.map { $0.frontText.lowercased() })
            
            self.performDatabaseOperation({
                try self.wordRepository.fetchCache(
                    count: needCount,
                    excludeIds: Array(existingIds),
                    excludeFrontTexts: Array(existingFrontTexts)
                )
            }, screen: .WordList, metadata: ["operation": "refill"])
            .sink { [weak self] completion in
                guard let self = self,
                      currentToken == self.cancellationToken else { return }
                
                if case .failure(let error) = completion {
                    Logger.error("[Word]: Refill failed", metadata: ["error": error.localizedDescription])
                    DispatchQueue.main.async {
                        self.isLoadingCache = false
                    }
                }
            } receiveValue: { [weak self] fetchedWords in
                guard let self = self,
                      currentToken == self.cancellationToken else { return }
                
                // Обработка новых слов
                self.processNewWords(fetchedWords, operation: "refill")
            }
            .store(in: &self.cancellables)
        }
    }
    
    private func processNewWords(_ words: [DatabaseModelWord], operation: String) {
        queue.async(flags: .barrier) { [weak self] in
            guard let self = self else { return }
            
            // Подготавливаем данные в бэкграунде
            let uniqueWords = self.validateAndFilterWords(words)
            Logger.debug("[Word]: Processing new words", metadata: [
                "operation": operation,
                "fetchedCount": String(words.count),
                "uniqueCount": String(uniqueWords.count)
            ])
            
            if !uniqueWords.isEmpty {
                let currentIds = Set(self.cache.compactMap { $0.id })
                let newWords = uniqueWords.filter { word in
                    guard let id = word.id else { return false }
                    return !currentIds.contains(id)
                }
                
                // Используем receive(on:) для переключения на главный поток
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    
                    // Теперь это выполняется на главном потоке
                    self.cache.append(contentsOf: newWords)
                    self.isLoadingCache = false
                    
                    Logger.info("[Word]: Cache updated", metadata: [
                        "operation": operation,
                        "addedWords": String(newWords.count),
                        "totalWords": String(self.cache.count),
                        "newWords": newWords.map { $0.frontText }.joined(separator: ", ")
                    ])
                }
            } else {
                DispatchQueue.main.async { [weak self] in
                    self?.isLoadingCache = false
                }
                Logger.warning("[Word]: No new unique words found", metadata: ["operation": operation])
            }
        }
    }
    
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
    
    deinit {
        Logger.debug("[Word]: Deinitializing cache")
        clearCache()
    }
}
