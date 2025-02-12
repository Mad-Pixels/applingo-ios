import Foundation
import Combine

/// A class responsible for fetching and managing dictionary data from the database.
/// Handles pagination, search, and data updates with validation and logging.
final class DictionaryGetter: ProcessDatabase {
    // MARK: - Public Properties
    
    @Published private(set) var dictionaries: [DatabaseModelDictionary] = []
    @Published private(set) var isLoadingPage = false
    @Published private(set) var hasLoadedInitialPage = false
    @Published var searchText: String = "" {
        didSet {
            if searchText != oldValue {
                resetPagination()
            }
        }
    }
    
    // MARK: - Private Properties
    
    private let dictionaryRepository: DatabaseManagerDictionary
    
    private struct PaginationState {
        var hasMorePages = true
        var currentPage = 0
        var token = UUID()
        
        mutating func reset() {
            hasMorePages = true
            currentPage = 0
            token = UUID()
        }
    }
    
    private var paginationState = PaginationState()
    private let itemsPerPage = 50
    private let preloadThreshold = 5
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    
    /// Initializes a new instance of DictionaryGetter by injecting the database queue.
    init() {
        guard let dbQueue = AppDatabase.shared.databaseQueue else {
            fatalError("Database is not connected")
        }
        
        self.dictionaryRepository = DatabaseManagerDictionary(dbQueue: dbQueue)
        super.init(dbQueue: dbQueue)
        
        setupNotifications()
    }
    
    deinit {
        Logger.debug("[Dictionary]: Deinitializing")
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Public Methods
    
    /// Updates the active status of a dictionary in the local array
    /// - Parameters:
    ///   - dictionaryID: The ID of the dictionary to update
    ///   - newStatus: The new active status
    func updateDictionaryStatus(dictionaryID: Int, newStatus: Bool) {
        guard let index = dictionaries.firstIndex(where: { $0.id == dictionaryID }) else {
            Logger.warning(
                "[Dictionary]: Attempted to update status for non-existent dictionary",
                metadata: [
                    "dictionaryId": String(dictionaryID),
                    "newStatus": String(newStatus)
                ]
            )
            return
        }
        
        Logger.debug(
            "[Dictionary]: Updating dictionary status in local array",
            metadata: [
                "dictionaryId": String(dictionaryID),
                "newStatus": String(newStatus),
                "index": String(index)
            ]
        )
        
        var updatedDictionary = dictionaries[index]
        updatedDictionary.isActive = newStatus
        dictionaries[index] = updatedDictionary
    }
    
    /// Removes a dictionary at the specified index
    /// - Parameter index: The index of the dictionary to remove
    func removeDictionary(at index: Int) {
        guard dictionaries.indices.contains(index) else {
            Logger.warning(
                "[Dictionary]: Attempted to remove dictionary at invalid index",
                metadata: [
                    "index": String(index),
                    "arrayCount": String(dictionaries.count)
                ]
            )
            return
        }
        
        Logger.debug(
            "[Dictionary]: Removing dictionary at index",
            metadata: [
                "index": String(index),
                "dictionary": dictionaries[index].name
            ]
        )
        dictionaries.remove(at: index)
    }
    
    /// Removes the specified dictionary from the array
    /// - Parameter dictionary: The dictionary to remove
    func removeDictionary(_ dictionary: DatabaseModelDictionary) {
        guard let index = dictionaries.firstIndex(where: { $0.id == dictionary.id }) else {
            Logger.warning(
                "[Dictionary]: Attempted to remove non-existent dictionary",
                metadata: [
                    "dictionaryId": dictionary.id.map(String.init) ?? "nil",
                    "dictionary": dictionary.name
                ]
            )
            return
        }
        removeDictionary(at: index)
    }
    
    /// Loads more dictionaries if needed based on the current item
    /// - Parameter currentItem: The currently visible dictionary item
    func loadMoreDictionariesIfNeeded(currentItem: DatabaseModelDictionary?) {
        guard let dictionary = currentItem,
              let index = dictionaries.firstIndex(where: { $0.id == dictionary.id }),
              index >= dictionaries.count - preloadThreshold,
              paginationState.hasMorePages,
              !isLoadingPage else {
            return
        }
        
        Logger.debug(
            "[Dictionary]: Loading more dictionaries",
            metadata: [
                "currentIndex": String(index),
                "totalCount": String(dictionaries.count)
            ]
        )
        fetchDictionaries()
    }
    
    /// Resets pagination and fetches first page
    func resetPagination() {
        Logger.debug("[Dictionary]: Resetting pagination")
        dictionaries.removeAll()
        hasLoadedInitialPage = false
        paginationState.reset()
        isLoadingPage = false
        fetchDictionaries()
    }
    
    /// Clears all loaded dictionaries.
    func clear() {
        Logger.debug("[Dictionary]: Clearing dictionaries")
        dictionaries.removeAll()
    }
    
    // MARK: - Private Methods
    
    private func setupNotifications() {
        Logger.debug("[Dictionary]: Setting up notifications")
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleDictionaryUpdate),
            name: .dictionaryListShouldUpdate,
            object: nil
        )
    }
    
    @objc private func handleDictionaryUpdate() {
        Logger.debug("[Dictionary]: Received dictionary update notification")
        resetPagination()
    }
    
    private func fetchDictionaries() {
        guard !isLoadingPage, paginationState.hasMorePages else {
            Logger.debug("[Dictionary]: Skipping fetch - already loading or no more pages")
            return
        }
        
        let currentToken = paginationState.token
        isLoadingPage = true
        Logger.debug(
            "[Dictionary]: Fetching dictionaries",
            metadata: [
                "page": String(paginationState.currentPage),
                "searchText": searchText
            ]
        )
        
        performDatabaseOperation(
            { try self.dictionaryRepository.fetch(
                search: self.searchText,
                offset: self.paginationState.currentPage * self.itemsPerPage,
                limit: self.itemsPerPage)
            },
            screen: screen,
            metadata: [
                "operation": "fetchDictionaries",
                "page": String(paginationState.currentPage),
                "searchText": searchText,
                "frame": screen.rawValue
            ]
        )
        .sink { [weak self] completion in
            guard let self = self, currentToken == self.paginationState.token else { return }
            self.isLoadingPage = false
            if case .failure(let error) = completion {
                Logger.warning("[Dictionary]: Failed to fetch dictionaries", metadata: ["error": "\(error)"])
            }
        } receiveValue: { [weak self] fetchedDictionaries in
            guard let self = self, currentToken == self.paginationState.token else {
                Logger.debug("[Dictionary]: Fetch cancelled or self deallocated")
                return
            }
            self.handleFetchSuccess(fetchedDictionaries)
        }
        .store(in: &cancellables)
    }
    
    private func handleFetchSuccess(_ fetchedDictionaries: [DatabaseModelDictionary]) {
        if fetchedDictionaries.isEmpty {
            Logger.debug("[Dictionary]: No more dictionaries to fetch")
            paginationState.hasMorePages = false
        } else {
            let validDictionaries = fetchedDictionaries.filter { dictionary in
                guard !dictionary.name.isEmpty else {
                    Logger.warning("[Dictionary]: Found dictionary with empty display name")
                    return false
                }
                return true
            }
            
            if validDictionaries.count != fetchedDictionaries.count {
                Logger.warning(
                    "[Dictionary]: Some dictionaries were filtered out",
                    metadata: [
                        "original": String(fetchedDictionaries.count),
                        "valid": String(validDictionaries.count)
                    ]
                )
            }
            
            paginationState.currentPage += 1
            dictionaries.append(contentsOf: validDictionaries)
            Logger.debug(
                "[Dictionary]: Dictionaries appended",
                metadata: [
                    "fetchedCount": String(validDictionaries.count),
                    "totalDictionaries": String(dictionaries.count)
                ]
            )
        }
        
        hasLoadedInitialPage = true
        isLoadingPage = false
    }
}
