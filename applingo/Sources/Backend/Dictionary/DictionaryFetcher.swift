import Foundation
import Combine

final class DictionaryFetcher: ProcessApi {
    @Published var dictionaries: [DatabaseModelDictionary] = []
    @Published var isLoadingPage = false
    @Published var searchText: String = "" {
        didSet {
            updateFilteredDictionaries()
            if !searchText.isEmpty && dictionaries.count < 5 && hasMorePages {
                get()
            }
        }
    }
    
    private var allDictionaries: [DatabaseModelDictionary] = []
    private var currentRequest: ApiDictionaryQueryRequestModel?
    private var hasMorePages = true
    private var lastEvaluated: String?
    
    /// Чтобы отличать этот экран от других
    private let screenType: ScreenType = .dictionariesRemote
    
    private var cancellationToken = UUID()

    override init() {
        super.init()
    }
    
    // MARK: - Pagination
    
    func resetPagination(with request: ApiDictionaryQueryRequestModel? = nil) {
        if let request = request {
            currentRequest = request
        }
        allDictionaries.removeAll()
        updateFilteredDictionaries()
        hasMorePages = true
        isLoadingPage = false
        lastEvaluated = nil
        cancellationToken = UUID()
        get()
    }
    
    func get(queryRequest: ApiDictionaryQueryRequestModel? = nil) {
        guard !isLoadingPage, hasMorePages else { return }
        
        let currentToken = cancellationToken
        isLoadingPage = true
        
        var request = queryRequest ?? currentRequest ?? ApiDictionaryQueryRequestModel()
        request.isPublic = true
        request.lastEvaluated = lastEvaluated
        
        Logger.debug("[DictionaryRemoteGetterViewModel] Making request with params: \(request)")
        
        performApiOperation(
            {
                // Асинхронный запрос к вашему ApiManagerCache
                try await ApiManagerCache.shared.getDictionaries(request: request)
            },
            success: { [weak self] (result: ([DatabaseModelDictionary], String?)) in
                guard let self = self else { return }
                guard currentToken == self.cancellationToken else {
                    self.isLoadingPage = false
                    return
                }
                
                let (fetchedDictionaries, newLastEvaluated) = result
                self.processFetchedDictionaries(fetchedDictionaries, lastEvaluated: newLastEvaluated)
                
                // Дополнительный вызов, если нужно подзагрузить ещё
                if !self.searchText.isEmpty && self.dictionaries.count < 5 && self.hasMorePages {
                    self.get()
                }
                self.isLoadingPage = false
            },
            screen: screenType,
            metadata: [
                "operation": "getDictionaries",
                "request": "\(request)",
                "searchText": searchText
            ],
            completion: { [weak self] _ in
                // В данном примере игнорируем Result, просто сбрасываем флаг
                self?.isLoadingPage = false
            }
        )
    }
    
    func loadMoreDictionariesIfNeeded(currentItem: DatabaseModelDictionary?) {
        guard
            let currentItem = currentItem,
            let index = dictionaries.firstIndex(where: { $0.id == currentItem.id }),
            index >= dictionaries.count - 5,
            hasMorePages,
            !isLoadingPage
        else {
            return
        }
        get()
    }
    
    func clear() {
        allDictionaries.removeAll()
        updateFilteredDictionaries()
        lastEvaluated = nil
        hasMorePages = true
    }
    
    // MARK: - Helpers
    
    private func processFetchedDictionaries(_ fetched: [DatabaseModelDictionary], lastEvaluated: String?) {
        if fetched.isEmpty {
            hasMorePages = false
        } else {
            allDictionaries.append(contentsOf: fetched)
            self.lastEvaluated = lastEvaluated
            hasMorePages = (lastEvaluated != nil)
            updateFilteredDictionaries()
        }
        Logger.debug("""
        [DictionaryRemoteGetterViewModel] Processed dictionaries: total(\(allDictionaries.count)), 
        filtered(\(dictionaries.count)), hasMore(\(hasMorePages)), searchText('\(searchText)')
        """)
    }
    
    private func updateFilteredDictionaries() {
        if searchText.isEmpty {
            dictionaries = allDictionaries
        } else {
            dictionaries = allDictionaries.filter { $0.matches(searchText: searchText) }
            Logger.debug("""
            [DictionaryRemoteGetterViewModel] Filtered dictionaries: 
            search('\(searchText)'), results(\(dictionaries.count)), total(\(allDictionaries.count))
            """)
        }
    }
}
