import Foundation
import Combine

final class GameCacheGetterViewModel: BaseDatabaseViewModel {
    @Published private(set) var cache: [WordItemModel] = []
    @Published private(set) var isLoadingCache = false
    
    private let repository: WordRepositoryProtocol
    private let cacheThreshold: Int = 20
    private let cacheSize: Int = 100
    
    private var cancellables = Set<AnyCancellable>()
    private var frame: AppFrameModel = .main
    private var cancellationToken = UUID()
    
    init(repository: WordRepositoryProtocol) {
        self.repository = repository
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
            { try self.repository.fetchCache(count: self.cacheSize) },
            successHandler: { [weak self] fetchedWords in
                guard let self = self,
                      currentToken == self.cancellationToken else { return }
                if fetchedWords.isEmpty {
                    self.isLoadingCache = false
                    return
                }
                self.cache = fetchedWords
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
        
        performDatabaseOperation(
            { try self.repository.fetchCache(count: needCount) },
            successHandler: { [weak self] fetchedWords in
                guard let self = self,
                      currentToken == self.cancellationToken else { return }
                if fetchedWords.isEmpty {
                    self.isLoadingCache = false
                    return
                }
                self.cache.append(contentsOf: fetchedWords)
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
    
    func removeFromCache(_ item: WordItemModel) {
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

