import Foundation
import Combine

/// A class responsible for fetching and managing remote dictionary data from the API.
/// Handles pagination, search, and caching of remote dictionaries.
final class DictionaryFetcher: ProcessApi {
    // MARK: - Constants
    
    private enum Constants {
        static let minSearchResults = 5
        static let preloadThreshold = 5
    }
    
    // MARK: - Published Properties
    
    @Published private(set) var dictionaries: [ApiModelDictionaryItem] = []
    @Published private(set) var isLoadingPage = false
    @Published private(set) var hasLoadedInitialPage = false
    @Published var searchText: String = "" {
        didSet {
            handleSearchTextChange(oldValue: oldValue)
        }
    }
    
    // MARK: - Private Properties
    
    private var allDictionaries: [ApiModelDictionaryItem] = []
    private var currentRequest: ApiModelDictionaryQueryRequest?
    private var hasMorePages = true
    private var lastEvaluated: String?
    private var token = UUID()
    
    // MARK: - Initialization
    
    override init() {
        super.init()
    }
    
    // MARK: - Public Methods
    
    /// Resets pagination state and starts new fetch with optional request
    /// - Parameter request: Optional new request to use for fetching
    func resetPagination(with request: ApiModelDictionaryQueryRequest? = nil) {
        Logger.debug(
            "[Dictionary]: Resetting pagination",
            metadata: [
                "hasRequest": String(request != nil),
                "currentCount": String(allDictionaries.count)
            ]
        )
        if let request = request {
            currentRequest = request
        }
        
        resetState()
        updateFilteredDictionaries()
        
        DispatchQueue.main.async {
            self.fetchDictionaries()
        }
    }
    
    /// Loads more dictionaries if needed based on the current item
    /// - Parameter currentItem: The current dictionary item being displayed
    func loadMoreDictionariesIfNeeded(currentItem: ApiModelDictionaryItem?) {
        guard let item = currentItem,
              let index = dictionaries.firstIndex(where: { $0.id == item.id }),
              index >= dictionaries.count - Constants.preloadThreshold,
              hasMorePages,
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
    
    /// Clears all loaded dictionaries and resets state
    func clear() {
        Logger.debug(
            "[Dictionary]: Clearing state",
            metadata: [
                "totalCount": String(allDictionaries.count)
            ]
        )
        resetState()
        updateFilteredDictionaries()
    }
    
    // MARK: - Private Methods
    
    /// Handles changes to search text
    private func handleSearchTextChange(oldValue: String) {
        Logger.debug(
            "[Dictionary]: Search text changed",
            metadata: [
                "oldValue": oldValue,
                "newValue": searchText
            ]
        )
        if searchText != oldValue {
            resetPagination()
        }
    }
    
    /// Resets all state variables to initial values
    private func resetState() {
        allDictionaries.removeAll()
        isLoadingPage = false
        hasMorePages = true
        hasLoadedInitialPage = false
        lastEvaluated = nil
        token = UUID()
    }
    
    /// Fetches dictionaries from the API
    private func fetchDictionaries() {
        guard !isLoadingPage, hasMorePages else {
            Logger.debug(
                "[Dictionary]: Skipping fetch",
                metadata: [
                    "isLoading": String(isLoadingPage),
                    "hasMorePages": String(hasMorePages)
                ]
            )
            return
        }

        let currentToken = token
        isLoadingPage = true
        
        var request = currentRequest ?? ApiModelDictionaryQueryRequest()
        request.isPublic = true
        request.lastEvaluated = lastEvaluated
        
        Logger.debug(
            "[Dictionary]: Fetching dictionaries",
            metadata: [
                "searchText": searchText,
                "lastEvaluated": lastEvaluated ?? "nil"
            ]
        )
        
        performApiOperation(
            { try await ApiManagerCache.shared.getDictionaries(request: request) },
            success: { [weak self] result in
                guard let self = self, currentToken == self.token else {
                    self?.isLoadingPage = false
                    return
                }
                
                self.handleFetchSuccess(result)
            },
            screen: screen,
            metadata: createMetadata(),
            completion: { [weak self] result in
                guard let self = self else { return }
                self.isLoadingPage = false
            }
        )
    }
    
    /// Handles successful dictionary fetch
    private func handleFetchSuccess(_ result: (dictionaries: [ApiModelDictionaryItem], lastEvaluated: String?)) {
        let (fetchedDictionaries, newLastEvaluated) = result
        
        if fetchedDictionaries.isEmpty {
            Logger.debug("[Dictionary]: No more dictionaries to fetch")
            hasMorePages = false
        } else {
            allDictionaries.append(contentsOf: fetchedDictionaries)
            lastEvaluated = newLastEvaluated
            hasMorePages = (newLastEvaluated != nil)
            
            Logger.debug(
                "[Dictionary]: Dictionaries fetched",
                metadata: [
                    "fetchedCount": String(fetchedDictionaries.count),
                    "totalCount": String(allDictionaries.count),
                    "hasMorePages": String(hasMorePages)
                ]
            )
            updateFilteredDictionaries()
        }
        
        hasLoadedInitialPage = true
        
        if !searchText.isEmpty &&
           dictionaries.count < Constants.minSearchResults &&
           hasMorePages {
            Logger.debug("[Dictionary]: Fetching more results to meet minimum requirement")
            fetchDictionaries()
        }
        isLoadingPage = false
    }
    
    /// Updates filtered dictionaries based on search text
    private func updateFilteredDictionaries() {
        Logger.debug(
            "[Dictionary]: Updating filtered dictionaries",
            metadata: [
                "totalCount": String(allDictionaries.count),
                "searchText": searchText
            ]
        )
        
        dictionaries = searchText.isEmpty
            ? allDictionaries
            : allDictionaries.filter { $0.matches(searchText: searchText) }
        
        Logger.debug(
            "[Dictionary]: Filtering completed",
            metadata: [
                "filteredCount": String(dictionaries.count)
            ]
        )
    }
    
    /// Creates metadata for API operations
    private func createMetadata() -> [String: String] {
        [
            "operation": "getDictionaries",
            "searchText": searchText,
            "totalCount": String(allDictionaries.count),
            "filteredCount": String(dictionaries.count),
            "frame": screen.rawValue
        ]
    }
}
