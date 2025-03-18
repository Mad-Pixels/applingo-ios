import Foundation
import Combine

/// A class responsible for fetching words from the database with pagination and search support.
final class WordGetter: ProcessDatabase {
    // MARK: - Public Properties
    @Published private(set) var words: [DatabaseModelWord] = []
    @Published private(set) var hasLoadedInitialPage = false
    @Published private(set) var hasLoadingError = false
    @Published private(set) var isLoadingPage = false

    @Published var searchText: String = "" {
        didSet {
            if searchText != oldValue {
                resetPagination()
            }
        }
    }
    
    // MARK: - Private Properties
    private let wordRepository: DatabaseManagerWord
    private var cancellables = Set<AnyCancellable>()
    private var loadingTask: AnyCancellable?
    private var cancellationToken = UUID()
    private var hasMorePages = true
    private let itemsPerPage = 50
    private var currentPage = 0
    
    // MARK: - Initialization
    init() {
        guard let dbQueue = AppDatabase.shared.databaseQueue else {
            fatalError("Database is not connected")
        }
        
        self.wordRepository = DatabaseManagerWord(dbQueue: dbQueue)
        super.init(dbQueue: dbQueue)
        
        setupNotifications()
    }
    
    // MARK: - Public Methods
    /// Resets pagination and fetches the first page of words.
    func resetPagination() {
        Logger.debug("[Word]: resetPagination")
        
        loadingTask?.cancel()
        loadingTask = nil
        
        words.removeAll()
        hasLoadedInitialPage = false
        currentPage = 0
        hasMorePages = true
        isLoadingPage = false
        hasLoadingError = false
        cancellationToken = UUID()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.get()
        }
    }
    
    /// Fetches words from the database with pagination and search support.
    func get() {
        guard !isLoadingPage, hasMorePages else {
            return
        }
        
        let fetchPage = currentPage
        let fetchToken = cancellationToken
        let fetchOffset = fetchPage * itemsPerPage
        
        isLoadingPage = true
        hasLoadingError = false
        
        Logger.debug(
            "[Word]: Download words",
            metadata: [
                "searchText": searchText,
                "page": "\(fetchPage)",
                "offset": "\(fetchOffset)",
                "limit": "\(itemsPerPage)"
            ]
        )
        
        loadingTask = performDatabaseOperation({
            try self.wordRepository.fetch(
                search: self.searchText,
                offset: fetchOffset,
                limit: self.itemsPerPage
            )
        }, screen: .WordList, metadata: ["searchText": searchText])
        .receive(on: DispatchQueue.main)
        .sink { [weak self] completion in
            guard let self = self, fetchToken == self.cancellationToken else { return }
            
            self.isLoadingPage = false
            self.loadingTask = nil
            
            if case .failure(let error) = completion {
                self.hasLoadingError = true
                Logger.warning("[Word]: Error getting words from database", metadata: ["error": "\(error)"])
            }
        } receiveValue: { [weak self] fetchedWords in
            guard let self = self, fetchToken == self.cancellationToken else { return }
            
            if fetchedWords.isEmpty {
                self.hasMorePages = false
                Logger.debug("[Word]: All words was downloaded")
            } else {
                self.currentPage += 1
                
                let existingIds = Set(self.words.compactMap { $0.id })
                let newWords = fetchedWords.filter { word in
                    guard let id = word.id else { return true }
                    return !existingIds.contains(id)
                }
                
                Logger.debug(
                    "[Word]: duplicates was filtered",
                    metadata: [
                        "originalCount": "\(fetchedWords.count)",
                        "filteredCount": "\(newWords.count)"
                    ]
                )
                
                if !newWords.isEmpty {
                    self.words.append(contentsOf: newWords)
                    Logger.debug(
                        "[Word]: Words list updated",
                        metadata: [
                            "added": "\(newWords.count)",
                            "all": "\(self.words.count)"
                        ]
                    )
                }
                
                if fetchedWords.count < self.itemsPerPage || newWords.isEmpty {
                    self.hasMorePages = false
                    Logger.debug("[Word]: End of the list")
                }
            }
            
            self.hasLoadedInitialPage = true
            self.isLoadingPage = false
        }
    }
    
    /// Triggers loading of more words when scrolling close to the bottom of the list.
    func loadMoreWordsIfNeeded(currentItem: DatabaseModelWord?) {
        guard
            let word = currentItem,
            let index = words.firstIndex(where: { $0.id == word.id }),
            !isLoadingPage,
            hasMorePages,
            index >= words.count - 10
        else {
            return
        }
        
        get()
    }
    
    /// Clears all loaded words.
    func clear() {
        loadingTask?.cancel()
        loadingTask = nil
        
        words.removeAll()
        hasLoadedInitialPage = false
        isLoadingPage = false
        hasLoadingError = false
        currentPage = 0
        hasMorePages = true
        cancellationToken = UUID()
    }
    
    // MARK: - Removal Methods
    
    /// Removes a word at the specified index.
    func removeWord(at index: Int) {
        guard words.indices.contains(index) else {
            Logger.warning(
                "[Word]: Cannot delete word by index, index out of bounds",
                metadata: [
                    "index": String(index),
                    "arrayCount": String(words.count)
                ]
            )
            return
        }
        
        words.remove(at: index)
    }
    
    /// Removes the specified word from the array.
    func removeWord(_ word: DatabaseModelWord) {
        guard let index = words.firstIndex(where: { $0.id == word.id }) else {
            Logger.warning(
                "[Word]: Word does not exist in the list",
                metadata: [
                    "wordId": word.id.map(String.init) ?? "nil",
                    "word": word.frontText
                ]
            )
            return
        }
        removeWord(at: index)
    }
    
    // MARK: - Private Methods
    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleWordUpdate),
            name: .wordListShouldUpdate,
            object: nil
        )
    }
    
    @objc private func handleWordUpdate() {
        resetPagination()
    }
}
