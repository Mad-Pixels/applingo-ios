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
    
    // MARK: - Private Properties
    
    private let wordRepository: DatabaseManagerWord
    private var cancellables = Set<AnyCancellable>()
    private var frame: ScreenType = .Home
    
    private var cancellationToken = UUID()
    private var hasMorePages = true
    private let itemsPerPage = 50
    private var currentPage = 0
    
    // MARK: - Initialization
    
    override init() {
        guard let dbQueue = AppDatabase.shared.databaseQueue else {
            fatalError("Database is not connected")
        }
        
        self.wordRepository = DatabaseManagerWord(dbQueue: dbQueue)
        super.init()
    }
    
    // MARK: - Public Methods
    
    /// Updates the current frame type for context tracking
    /// - Parameter newFrame: The new frame type to set
    func setFrame(_ newFrame: ScreenType) {
        Logger.debug(
            "[Word]: Setting frame",
            metadata: [
                "oldFrame": frame.rawValue,
                "newFrame": newFrame.rawValue
            ]
        )
        self.frame = newFrame
    }
    
    /// Removes a word at the specified index
    /// - Parameter index: The index of the word to remove
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
        
        Logger.info("[Word]: Removing word at index", metadata: [
            "index": String(index),
            "word": words[index].frontText
        ])
        words.remove(at: index)
    }
    
    /// Removes the specified word from the array
    /// - Parameter word: The word to remove
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
    
    /// Resets pagination and fetches the first page of words.
    func resetPagination() {
        Logger.info("[Word]: Resetting pagination")
        words.removeAll()
        
        currentPage = 0
        hasMorePages = true
        isLoadingPage = false
        cancellationToken = UUID()
        
        DispatchQueue.main.async {
            self.get()
        }
    }
    
    /// Fetches words from the database with pagination and search support.
    func get() {
        guard !isLoadingPage, hasMorePages else {
            Logger.debug("[Word]: Skipping get() - already loading or no more pages")
            return
        }
        
        let currentToken = cancellationToken
        isLoadingPage = true
        Logger.info(
            "[Word]: Fetching words",
            metadata: [
                "searchText": searchText,
                "currentPage": "\(currentPage)",
                "itemsPerPage": "\(itemsPerPage)"
            ]
        )
        
        performDatabaseOperation(
            {
                try self.wordRepository.fetch(
                    search: self.searchText,
                    offset: self.currentPage * self.itemsPerPage,
                    limit: self.itemsPerPage
                )
            },
            success: { [weak self] fetchedWords in
                guard let self = self, currentToken == self.cancellationToken else { return }
                self.handleFetchedWords(fetchedWords)
            },
            screen: .WordList,
            metadata: ["searchText": searchText],
            completion: { [weak self] result in
                guard let self = self, currentToken == self.cancellationToken else { return }
                
                if case .failure(let error) = result {
                    Logger.error(
                        "[Word]: Fetch failed",
                        metadata: [
                            "error": error.localizedDescription
                        ]
                    )
                }
                
                self.isLoadingPage = false
            }
        )
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
        Logger.info("[Word]: Clearing words")
        words.removeAll()
    }
    
    // MARK: - Private Methods
    
    /// Handles fetched words and updates pagination state.
    private func handleFetchedWords(_ fetchedWords: [DatabaseModelWord]) {
        DispatchQueue.main.async {
            if fetchedWords.isEmpty {
                self.hasMorePages = false
                Logger.info("[Word]: No more words to fetch")
            } else {
                self.currentPage += 1
                self.words.append(contentsOf: fetchedWords)
                Logger.info(
                    "[Word]: Words appended",
                    metadata: [
                        "fetchedCount": "\(fetchedWords.count)",
                        "totalWords": "\(self.words.count)"
                    ]
                )
            }
            
            self.isLoadingPage = false
        }
    }
}
