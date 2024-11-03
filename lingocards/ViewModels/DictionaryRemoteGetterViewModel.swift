import Foundation
import Combine

final class DictionaryRemoteGetterViewModel: BaseApiViewModel {
    @Published var dictionaries: [DictionaryItemModel] = []
    @Published var isLoadingPage = false
    @Published var searchText: String = "" {
        didSet {
            if searchText != oldValue {
                resetPagination()
            }
        }
    }

    private var hasMorePages = true
    private var lastEvaluated: String?
    private var frame: AppFrameModel = .main
    private var cancellationToken = UUID()

    func resetPagination() {
        dictionaries.removeAll()
        hasMorePages = true
        isLoadingPage = false
        lastEvaluated = nil
        cancellationToken = UUID()
        get()
    }

    func get(queryRequest: DictionaryQueryRequest? = nil) {
        guard !isLoadingPage, hasMorePages else {
            return
        }
        let currentToken = cancellationToken
        isLoadingPage = true

        var request = queryRequest ?? DictionaryQueryRequest()
        request.isPrivate = false
        request.lastEvaluated = self.lastEvaluated
        if !searchText.isEmpty {
            request.name = searchText
        }
        performApiOperation(
            {
                let bodyData = try JSONEncoder().encode(request)
                let data = try await APIManager.shared.request(
                    endpoint: "/device/v1/dictionary/query",
                    method: .post,
                    body: bodyData
                )
                let response = try JSONDecoder().decode(DictionaryQueryResponse.self, from: data)
                return response
            },
            successHandler: { [weak self] response in
                guard let self = self else { return }
                guard currentToken == self.cancellationToken else {
                    self.isLoadingPage = false
                    return
                }
                let fetchedDictionaries = response.data.items
                self.processFetchedDictionaries(fetchedDictionaries, lastEvaluated: response.lastEvaluated)
                self.isLoadingPage = false
            },
            errorType: .api,
            errorSource: .dictionariesRemoteGet,
            errorMessage: "Failed to load remote dictionaries",
            frame: frame,
            completion: { [weak self] result in
                guard let self = self else { return }
                self.isLoadingPage = false
            }
        )
    }

    func loadMoreDictionariesIfNeeded(currentItem: DictionaryItemModel?) {
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
        dictionaries = []
        lastEvaluated = nil
        hasMorePages = true
    }
    
    func setFrame(_ newFrame: AppFrameModel) {
        self.frame = newFrame
    }
    
    private func processFetchedDictionaries(_ fetchedDictionaries: [DictionaryItemModel], lastEvaluated: String?) {
        if fetchedDictionaries.isEmpty {
            hasMorePages = false
        } else {
            dictionaries.append(contentsOf: fetchedDictionaries)
            self.lastEvaluated = lastEvaluated
            hasMorePages = (lastEvaluated != nil)
        }
    }
}
