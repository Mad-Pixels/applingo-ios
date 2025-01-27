import Foundation
import Combine

final class WordCache: ProcessDatabase {
    @Published private(set) var cache: [DatabaseModelWord] = []
    @Published private(set) var isLoadingCache = false
    
    private let wordRepository: DatabaseManagerWord
    private let cacheThreshold: Int = 20
    private let cacheSize: Int = 100
    private let queue = DispatchQueue(label: "com.applingo.wordcache", attributes: .concurrent)
    
    private var cancellables = Set<AnyCancellable>()
    private var cancellationToken = UUID()
    private var frame: AppFrameModel = .main
    
    override init() {
        guard let dbQueue = AppDatabase.shared.databaseQueue else {
            fatalError("Database is not connected")
        }
        self.wordRepository = DatabaseManagerWord(dbQueue: dbQueue)
        super.init()
        setupCacheObserver()
    }
    
    private func setupCacheObserver() {
        $cache
            .dropFirst()
            .filter { $0.count < self.cacheThreshold }
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                if !self.cache.isEmpty {
                    self.refillCache()
                }
            }
            .store(in: &cancellables)
    }
    
    func initializeCache() {
        queue.async { [weak self] in
            guard let self = self else { return }
            
            var shouldLoad = false
            self.queue.sync(flags: .barrier) {
                if !self.isLoadingCache {
                    self.isLoadingCache = true
                    shouldLoad = true
                }
            }
            
            guard shouldLoad else { return }
            
            let currentToken = self.cancellationToken
            
            self.performDatabaseOperation(
                { try self.wordRepository.fetchCache(count: self.cacheSize) },
                success: { [weak self] fetchedWords in
                    guard let self = self,
                          currentToken == self.cancellationToken else { return }
                    
                    self.queue.async(flags: .barrier) {
                        if fetchedWords.isEmpty {
                            self.isLoadingCache = false
                            return
                        }
                        
                        var uniqueFrontText = Set<String>()
                        let uniqueWords = fetchedWords.filter { word in
                            uniqueFrontText.insert(word.frontText.lowercased()).inserted
                        }
                        
                        self.cache = uniqueWords
                        self.isLoadingCache = false
                    }
                },
                screen: .words,
                metadata: ["operation": "initializeCache", "frameType": frame.rawValue],
                completion: { [weak self] result in
                    guard let self = self,
                          currentToken == self.cancellationToken else { return }
                    
                    if case .failure = result {
                        self.queue.async(flags: .barrier) {
                            self.isLoadingCache = false
                        }
                    }
                }
            )
        }
    }
    
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
            
            guard shouldLoad else { return }
            
            let needCount = self.cacheSize - self.cache.count
            guard needCount > 0 else {
                self.isLoadingCache = false
                return
            }
            
            let currentToken = self.cancellationToken
            let existingIds = Set(self.cache.map { $0.id })
            let existingFrontTexts = Set(self.cache.map { $0.frontText.lowercased() })
            
            self.performDatabaseOperation(
                { try self.wordRepository.fetchCache(count: needCount) },
                success: { [weak self] fetchedWords in
                    guard let self = self,
                          currentToken == self.cancellationToken else { return }
                    
                    self.queue.async(flags: .barrier) {
                        let newWords = fetchedWords.filter { word in
                            !existingIds.contains(word.id) &&
                            !existingFrontTexts.contains(word.frontText.lowercased())
                        }
                        
                        if !newWords.isEmpty {
                            let availableSpace = self.cacheSize - self.cache.count
                            if availableSpace > 0 {
                                self.cache.append(contentsOf: Array(newWords.prefix(availableSpace)))
                            }
                        }
                        self.isLoadingCache = false
                    }
                },
                screen: .words,
                metadata: [
                    "operation": "refillCache",
                    "currentCount": String(self.cache.count),
                    "needCount": String(needCount),
                    "frameType": frame.rawValue
                ],
                completion: { [weak self] result in
                    guard let self = self,
                          currentToken == self.cancellationToken else { return }
                    
                    if case .failure = result {
                        self.queue.async(flags: .barrier) {
                            self.isLoadingCache = false
                        }
                    }
                }
            )
        }
    }
    
    func removeFromCache(_ item: DatabaseModelWord) {
        queue.async(flags: .barrier) {
            self.cache.removeAll { $0.id == item.id }
        }
    }
    
    func clearCache() {
        queue.async(flags: .barrier) {
            self.cancellationToken = UUID()
            self.cache.removeAll()
            self.isLoadingCache = false
        }
    }
    
    func setFrame(_ newFrame: AppFrameModel) {
        self.frame = newFrame
    }
    
    deinit {
        clearCache()
    }
}
