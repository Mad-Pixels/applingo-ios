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
    private var loadingPages = Set<Int>()
    private var cancellationToken = UUID()
    private var hasMorePages = true
    private var isResetting = false
    private var lastFetchedCount = 0
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
        guard !isResetting else {
            Logger.debug("[Word]: Request already running")
            return
        }
        
        isResetting = true
        Logger.debug("[Word]: resetPagination")
        
        cancellationToken = UUID()
        loadingPages.removeAll()
        
        words.removeAll()
        hasLoadedInitialPage = false
        currentPage = 0
        hasMorePages = true
        isLoadingPage = false
        hasLoadingError = false
        lastFetchedCount = 0
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let self = self else { return }
            self.isResetting = false
            self.get()
        }
    }
    
    /// Fetches words from the database with pagination and search support.
    func get() {
        guard
            !isResetting,
            !isLoadingPage,
            hasMorePages,
            !loadingPages.contains(currentPage)
        else {
            Logger.debug("[Word]: Skip request - state do not allow to execute request")
            return
        }
        
        let fetchPage = currentPage
        let fetchToken = cancellationToken
        let fetchOffset = fetchPage * itemsPerPage
        
        isLoadingPage = true
        loadingPages.insert(fetchPage)
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
        
        performDatabaseOperation({
            try self.wordRepository.fetch(
                search: self.searchText,
                offset: fetchOffset,
                limit: self.itemsPerPage
            )
        }, screen: .WordList, metadata: ["searchText": searchText])
        .receive(on: DispatchQueue.main)
        .sink { [weak self] completion in
            guard
                let self = self,
                fetchToken == self.cancellationToken,
                self.loadingPages.contains(fetchPage)
            else { return }
            
            self.isLoadingPage = false
            self.loadingPages.remove(fetchPage)
            
            if case .failure(let error) = completion {
                self.hasLoadingError = true
                Logger.warning("[Word]: Error getting words from database", metadata: ["error": "\(error)"])
            }
        } receiveValue: { [weak self] fetchedWords in
            guard
                let self = self,
                fetchToken == self.cancellationToken,
                self.loadingPages.contains(fetchPage)
            else { return }
            
            self.processFetchedWords(fetchedWords, forPage: fetchPage)
        }
        .store(in: &cancellables)
    }
    
    /// Triggers loading of more words when scrolling close to the bottom of the list.
    func loadMoreWordsIfNeeded(currentItem: DatabaseModelWord?) {
        guard
            let word = currentItem,
            let index = words.firstIndex(where: { $0.id == word.id }),
            !isResetting,
            !isLoadingPage,
            hasMorePages,
            index >= words.count - 10
        else {
            return
        }
        
        Logger.debug("[Word]: Prepare to get new words (index: \(index), all: \(words.count))")
        get()
    }
    
    /// Clears all loaded words.
    func clear() {
        Logger.debug("[Word]: cleanup words")
        words.removeAll()
        hasLoadedInitialPage = false
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
        
        Logger.debug(
            "[Word]: Removing word",
            metadata: [
                "index": String(index),
                "word": words[index].frontText
            ]
        )
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
        Logger.debug("[Word]: Received word update notification")
        resetPagination()
    }
    
    private func processFetchedWords(_ fetchedWords: [DatabaseModelWord], forPage page: Int) {
        guard page == currentPage, !isResetting else {
            return
        }
        
        if fetchedWords.isEmpty {
            hasMorePages = false
            Logger.debug("[Word]: All words was downloaded")
            return
        }
        
        currentPage += 1
        lastFetchedCount = fetchedWords.count
        
        let existingIds = Set(words.compactMap { $0.id })
        let newWords = fetchedWords.filter { word in
            guard let id = word.id else { return true }
            return !existingIds.contains(id)
        }
        
        if newWords.isEmpty && fetchedWords.count < itemsPerPage {
            hasMorePages = false
            Logger.debug("[Word]: End of the list (repeated data)")
            return
        }
        
        Logger.debug(
            "[Word]: duplicates was filtered",
            metadata: [
                "originalCount": "\(fetchedWords.count)",
                "filteredCount": "\(newWords.count)"
            ]
        )
        
        if !newWords.isEmpty {
            words.append(contentsOf: newWords)
            Logger.debug(
                "[Word]: Words list updated",
                metadata: [
                    "added": "\(newWords.count)",
                    "all": "\(words.count)"
                ]
            )
        }
        hasLoadedInitialPage = true
        
        if fetchedWords.count < itemsPerPage {
            hasMorePages = false
            Logger.debug("[Word]: End of the list (not full page)")
        }
    }
}
