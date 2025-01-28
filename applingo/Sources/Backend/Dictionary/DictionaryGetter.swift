import Foundation
import Combine

/// A class responsible for fetching and managing dictionary data from the database.
///
/// `DictionaryGetter` handles pagination, search, and data updates. It extends `ProcessDatabase`
/// to leverage centralized error handling and database operation utilities.
final class DictionaryGetter: ProcessDatabase {
    // MARK: - Constants
    
    /// Constants used for pagination and preloading.
    private enum Constants {
        static let itemsPerPage = 50
        static let preloadThreshold = 5
    }
    
    // MARK: - Published Properties
    
    @Published var dictionaries: [DatabaseModelDictionary] = []
    @Published var isLoadingPage = false
    @Published var searchText: String = "" {
        didSet { handleSearchTextChange(oldValue: oldValue) }
    }
    
    // MARK: - Private Properties
    
    /// The repository responsible for interacting with the database.
    private let dictionaryRepository: DatabaseManagerDictionary
    private var paginationState = PaginationState()
    private var screen: ScreenType = .Home
    
    // MARK: - Initialization
    
    /// Initializes the `DictionaryGetter` with the necessary dependencies.
    override init() {
        guard let dbQueue = AppDatabase.shared.databaseQueue else {
            fatalError("Database is not connected")
        }
        self.dictionaryRepository = DatabaseManagerDictionary(dbQueue: dbQueue)
        super.init()
        setupNotifications()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Public Methods
    
    /// Loads more dictionaries if needed based on the current item and preload threshold.
    /// - Parameter currentItem: The current dictionary item being displayed.
    func loadMoreDictionariesIfNeeded(currentItem: DatabaseModelDictionary?) {
        guard let dictionary = currentItem,
              let index = dictionaries.firstIndex(where: { $0.id == dictionary.id }),
              index >= dictionaries.count - Constants.preloadThreshold,
              paginationState.hasMorePages,
              !isLoadingPage else { return }
        
        fetchDictionaries()
    }
    
    /// Resets the pagination state and reloads dictionaries.
    func resetPagination() {
        Logger.debug("[Getter]: Resetting dictionary pagination state", metadata: createMetadata())
        dictionaries.removeAll()
        paginationState.reset()
        isLoadingPage = false
        fetchDictionaries()
    }
    
    /// Sets the current screen type for tracking context in operations.
    /// - Parameter screen: The screen type to set.
    func setFrame(_ screen: ScreenType) {
        Logger.debug("[Getter]: Setting frame", metadata: ["frame": screen.rawValue])
        self.screen = screen
    }
    
    // MARK: - Private Methods
    
    /// Sets up notification observers for handling dictionary updates.
    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleDictionaryUpdate),
            name: .dictionaryListShouldUpdate,
            object: nil
        )
    }
    
    /// Handles updates to the dictionary list triggered by a notification.
    @objc private func handleDictionaryUpdate() {
        Logger.debug("[Getter]: Dictionary update notification received")
        resetPagination()
    }
    
    /// Handles changes to the search text and resets pagination when it changes.
    /// - Parameter oldValue: The previous value of the search text.
    private func handleSearchTextChange(oldValue: String) {
        guard searchText != oldValue else { return }
        Logger.debug("[Getter]: Search text changed", metadata: ["oldValue": oldValue, "newValue": searchText])
        resetPagination()
    }
    
    /// Fetches dictionaries from the database using the repository.
    private func fetchDictionaries() {
        guard !isLoadingPage, paginationState.hasMorePages else { return }
        
        let currentToken = paginationState.token
        isLoadingPage = true
                
        performDatabaseOperation(
            { try self.fetchDictionariesFromRepository() },
            success: { [weak self] in
                self?.handleFetchSuccess($0, token: currentToken)
            },
            screen: screen,
            metadata: createMetadata(),
            completion: { [weak self] result in
                self?.handleFetchCompletion(result, token: currentToken)
            }
        )
    }
    
    /// Fetches dictionaries from the repository with the current search and pagination state.
    /// - Returns: An array of dictionaries from the database.
    private func fetchDictionariesFromRepository() throws -> [DatabaseModelDictionary] {
        return try dictionaryRepository.fetch(
            search: searchText,
            offset: paginationState.currentPage * Constants.itemsPerPage,
            limit: Constants.itemsPerPage
        )
    }
    
    /// Creates metadata for the current fetch operation.
    /// - Returns: A dictionary containing metadata for debugging and logging.
    private func createMetadata() -> [String: String] {
        [
            "operation": "getDictionaries",
            "searchText": searchText,
            "currentPage": "\(paginationState.currentPage)",
            "itemsPerPage": "\(Constants.itemsPerPage)",
            "frame": screen.rawValue
        ]
    }
    
    /// Handles the successful fetching of dictionaries.
    /// - Parameters:
    ///   - fetchedDictionaries: The dictionaries fetched from the database.
    ///   - token: The token identifying the current pagination state.
    private func handleFetchSuccess(
        _ fetchedDictionaries: [DatabaseModelDictionary],
        token: UUID
    ) {
        guard token == paginationState.token else {
            isLoadingPage = false
            return
        }
        
        if fetchedDictionaries.isEmpty {
            Logger.debug("[Getter]: No more dictionaries to fetch")
            paginationState.hasMorePages = false
        } else {
            paginationState.currentPage += 1
            dictionaries.append(contentsOf: fetchedDictionaries)
        }
        isLoadingPage = false
    }
    
    /// Handles the completion of a fetch operation.
    /// - Parameters:
    ///   - result: The result of the fetch operation, indicating success or failure.
    ///   - token: The token identifying the current pagination state.
    private func handleFetchCompletion(_ result: Result<Void, Error>, token: UUID) {
        guard token == paginationState.token else {
            return
        }
        if case .failure(_) = result {
            isLoadingPage = false
        }
    }
}

// MARK: - Pagination State

/// A struct to manage the state of pagination.
private struct PaginationState {
    var hasMorePages = true
    var currentPage = 0
    var token = UUID()
    
    /// Resets the pagination state to its initial values.
    mutating func reset() {
        hasMorePages = true
        currentPage = 0
        token = UUID()
    }
}
