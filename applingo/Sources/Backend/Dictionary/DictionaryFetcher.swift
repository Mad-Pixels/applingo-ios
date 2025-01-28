import Foundation
import Combine

/// A class responsible for fetching and managing remote dictionary data from the API.
///
/// `DictionaryFetcher` handles pagination, search, and caching of remote dictionaries.
final class DictionaryFetcher: ProcessApi {
   // MARK: - Constants
   
   private enum Constants {
       static let minSearchResults = 5
       static let preloadThreshold = 5
   }
   
   // MARK: - Published Properties
   
   @Published var dictionaries: [ApiModelDictionaryItem] = []
   @Published var isLoadingPage = false
   @Published var searchText: String = "" {
       didSet {
           updateFilteredDictionaries()
           if !searchText.isEmpty && dictionaries.count < Constants.minSearchResults && hasMorePages {
               fetchDictionaries()
           }
       }
   }
   
   // MARK: - Private Properties
   
   private var allDictionaries: [ApiModelDictionaryItem] = []
   private var currentRequest: ApiModelDictionaryQueryRequest?
   private var hasMorePages = true
   private var lastEvaluated: String?
   private let screenType: ScreenType = .DictionaryRemoteList
   private var token = UUID()
   
   // MARK: - Initialization
   
   override init() {
       super.init()
   }
   
   // MARK: - Public Methods
   
   func resetPagination(with request: ApiModelDictionaryQueryRequest? = nil) {
       Logger.debug("[Fetcher]: Resetting pagination state", metadata: createMetadata())
       
       if let request = request {
           currentRequest = request
       }
       allDictionaries.removeAll()
       hasMorePages = true
       isLoadingPage = false
       lastEvaluated = nil
       token = UUID()
       
       updateFilteredDictionaries()
       fetchDictionaries()
   }
   
   func loadMoreDictionariesIfNeeded(currentItem: ApiModelDictionaryItem?) {
       guard let item = currentItem,
             let index = dictionaries.firstIndex(where: { $0.id == item.id }),
             index >= dictionaries.count - Constants.preloadThreshold,
             hasMorePages,
             !isLoadingPage else { return }
       
       fetchDictionaries()
   }
   
   func clear() {
       allDictionaries.removeAll()
       updateFilteredDictionaries()
       hasMorePages = true
       lastEvaluated = nil
       token = UUID()
   }
   
   // MARK: - Private Methods
   
   private func fetchDictionaries() {
       guard !isLoadingPage, hasMorePages else { return }
       
       let currentToken = token
       isLoadingPage = true
       
       var request = currentRequest ?? ApiModelDictionaryQueryRequest()
       request.isPublic = true
       request.lastEvaluated = lastEvaluated
       
       Logger.debug("[Fetcher]: Fetching dictionaries", metadata: createMetadata())
       
       performApiOperation(
           { try await ApiManagerCache.shared.getDictionaries(request: request) },
           success: { [weak self] result in
               guard let self = self, currentToken == self.token else {
                   self?.isLoadingPage = false
                   return
               }
               
               let (dictionaries, lastEvaluated) = result
               
               if dictionaries.isEmpty {
                   self.hasMorePages = false
               } else {
                   self.allDictionaries.append(contentsOf: dictionaries)
                   self.lastEvaluated = lastEvaluated
                   self.hasMorePages = (lastEvaluated != nil)
                   self.updateFilteredDictionaries()
               }
               
               if !self.searchText.isEmpty &&
                  self.dictionaries.count < Constants.minSearchResults &&
                  self.hasMorePages {
                   self.fetchDictionaries()
               }
               
               self.isLoadingPage = false
           },
           screen: screenType,
           metadata: createMetadata(),
           completion: { [weak self] _ in
               self?.isLoadingPage = false
           }
       )
   }
   
   private func updateFilteredDictionaries() {
       Logger.debug("[Fetcher]: Updating filtered dictionaries", metadata: [
           "totalCount": "\(allDictionaries.count)",
           "searchText": searchText
       ])
       
       dictionaries = searchText.isEmpty
           ? allDictionaries
           : allDictionaries.filter { $0.matches(searchText: searchText) }
   }
   
   private func createMetadata() -> [String: String] {
       [
           "operation": "getDictionaries",
           "searchText": searchText,
           "totalCount": "\(allDictionaries.count)"
       ]
   }
}
