import Foundation
import Combine

final class GameCacheGetterViewModel: BaseDatabaseViewModel {
    @Published private(set) var cache: [DatabaseModelWord] = []
    @Published private(set) var isLoadingCache = false
    
    private let wordRepository: WordRepositoryProtocol
    private let cacheThreshold: Int = 20
    private let cacheSize: Int = 100
    
    private var cancellables = Set<AnyCancellable>()
    private var frame: AppFrameModel = .main
    private var cancellationToken = UUID()
    
    override init() {
        guard let dbQueue = AppDatabase.shared.databaseQueue else {
            fatalError("Database is not connected")
        }
        self.wordRepository = RepositoryWord(dbQueue: dbQueue)
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
        guard !isLoadingCache else { return }
        
        let currentToken = cancellationToken
        isLoadingCache = true
        
        performDatabaseOperation(
            { try self.wordRepository.fetchCache(count: self.cacheSize) },
            successHandler: { [weak self] fetchedWords in
                guard let self = self,
                      currentToken == self.cancellationToken else { return }
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
            },
            source: .wordsGet,
            frame: frame,
            message: "Failed to initialize cache",
            completion: { [weak self] result in
                guard let self = self,
                      currentToken == self.cancellationToken else { return }
                if case .failure = result {
                    self.isLoadingCache = false
                }
            }
        )
    }
    
    private func refillCache() {
        guard !isLoadingCache else { return }
        
        let needCount = cacheSize - cache.count
        guard needCount > 0 else { return }
        
        let currentToken = cancellationToken
        isLoadingCache = true
        
        let existingIds = Set(cache.map { $0.id })
        let existingFrontTexts = Set(cache.map { $0.frontText.lowercased() })
        
        performDatabaseOperation(
            { try self.wordRepository.fetchCache(count: needCount) },
            successHandler: { [weak self] fetchedWords in
                guard let self = self,
                      currentToken == self.cancellationToken else { return }
                
                let newWords = fetchedWords.filter { word in
                    !existingIds.contains(word.id) &&
                    !existingFrontTexts.contains(word.frontText.lowercased())
                }
                
                if !newWords.isEmpty {
                    self.cache.append(contentsOf: newWords)
                }
                self.isLoadingCache = false
            },
            source: .wordsGet,
            frame: frame,
            message: "Failed to refill cache",
            completion: { [weak self] result in
                guard let self = self,
                      currentToken == self.cancellationToken else { return }
                if case .failure = result {
                    self.isLoadingCache = false
                }
            }
        )
    }
    
    func removeFromCache(_ item: DatabaseModelWord) {
        cache.removeAll { $0.id == item.id }
    }
    
    func clearCache() {
        cancellationToken = UUID()
        cache.removeAll()
        isLoadingCache = false
    }
    
    func setFrame(_ newFrame: AppFrameModel) {
        self.frame = newFrame
    }
    
    deinit {
        clearCache()
    }
}

