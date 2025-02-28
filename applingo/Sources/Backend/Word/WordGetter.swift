import Foundation
import Combine

/// A class responsible for fetching words from the database with pagination and search support.
final class WordGetter: ProcessDatabase {
    // MARK: - Public Properties
    @Published private(set) var words: [DatabaseModelWord] = []
    @Published private(set) var isLoadingPage = false
    
    @Published var searchText: String = "" {
        didSet {
            if searchText != oldValue {
                resetPagination()
            }
        }
    }
    
    /// Indicates whether the first page has been loaded.
    @Published private(set) var hasLoadedInitialPage = false
    
    // MARK: - Private Properties
    private let wordRepository: DatabaseManagerWord
    private var cancellables = Set<AnyCancellable>()
    
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
    }
    
    // MARK: - Public Methods
    
    /// Resets pagination and fetches the first page of words.
    func resetPagination() {
        Logger.debug("[Word]: Resetting pagination")
        words.removeAll()
        hasLoadedInitialPage = false  // Reset the initial load flag
        
        currentPage = 0
        hasMorePages = true
        cancellationToken = UUID()
        // Reset isLoadingPage in case a previous operation didn't finish properly.
        isLoadingPage = false
        
        DispatchQueue.main.async {
            self.get()
        }
    }
    
    /// Fetches words from the database with pagination and search support.
    func get() {
        // If a load is already in progress or no more pages, skip the request.
        guard !isLoadingPage, hasMorePages else {
            Logger.debug("[Word]: Skipping get() - already loading or no more pages")
            return
        }
        
        let currentToken = cancellationToken
        isLoadingPage = true
        Logger.debug(
            "[Word]: Fetching words",
            metadata: [
                "searchText": searchText,
                "currentPage": "\(currentPage)",
                "itemsPerPage": "\(itemsPerPage)"
            ]
        )
        
        performDatabaseOperation({
            try self.wordRepository.fetch(
                search: self.searchText,
                offset: self.currentPage * self.itemsPerPage,
                limit: self.itemsPerPage
            )
        }, screen: .WordList, metadata: ["searchText": searchText])
        .sink { [weak self] completion in
            guard let self = self, currentToken == self.cancellationToken else { return }
            self.isLoadingPage = false
            if case .failure(let error) = completion {
                Logger.warning("[Word]: Failed to fetch words", metadata: ["error": "\(error)"])
            }
        } receiveValue: { [weak self] fetchedWords in
            guard let self = self, currentToken == self.cancellationToken else { return }
            self.handleFetchedWords(fetchedWords)
        }
        .store(in: &cancellables)
    }
    
    /// Triggers loading of more words when scrolling close to the bottom of the list.
    func loadMoreWordsIfNeeded(currentItem: DatabaseModelWord?) {
        guard
            let word = currentItem,
            let index = words.firstIndex(where: { $0.id == word.id }),
            index >= words.count - 5,
            hasMorePages,
            !isLoadingPage
        else {
            return
        }
        
        Logger.debug("[Word]: Loading more words as user scrolled down")
        get()
    }
    
    /// Clears all loaded words.
    func clear() {
        Logger.debug("[Word]: Clearing words")
        words.removeAll()
    }
    
    // MARK: - Removal Methods
    
    /// Removes a word at the specified index.
    func removeWord(at index: Int) {
        guard words.indices.contains(index) else {
            Logger.warning(
                "[Word]: Attempted to remove word at invalid index",
                metadata: [
                    "index": String(index),
                    "arrayCount": String(words.count)
                ]
            )
            return
        }
        
        Logger.debug(
            "[Word]: Removing word at index",
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
                "[Word]: Attempted to remove non-existent word",
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
    
    /// Handles fetched words and updates pagination state.
    private func handleFetchedWords(_ fetchedWords: [DatabaseModelWord]) {
        DispatchQueue.main.async {
            if fetchedWords.isEmpty {
                self.hasMorePages = false
                Logger.debug("[Word]: No more words to fetch")
            } else {
                self.currentPage += 1
                self.words.append(contentsOf: fetchedWords)
                Logger.debug(
                    "[Word]: Words appended",
                    metadata: [
                        "fetchedCount": "\(fetchedWords.count)",
                        "totalWords": "\(self.words.count)"
                    ]
                )
            }
            
            self.hasLoadedInitialPage = true  // Set the flag after the first successful load
            self.isLoadingPage = false
        }
    }
}
