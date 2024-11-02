import Foundation
import Combine

final class DictionaryRemoteGetterViewModel: ObservableObject {
    @Published var dictionaries: [DictionaryItemModel] = []
    @Published var searchText: String = "" {
        didSet {
            if searchText != oldValue {
                resetPagination()
            }
        }
    }
    @Published var isLoadingPage = false

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
        request.is_public = true
        request.last_evaluated = self.lastEvaluated
        request.limit = 20

        if !searchText.isEmpty {
            request.name = searchText
        }

        Task {
            do {
                let bodyData = try JSONEncoder().encode(request)
                let data = try await APIManager.shared.request(
                    endpoint: "/device/v1/dictionary/query",
                    method: .post,
                    body: bodyData
                )

                let response = try JSONDecoder().decode(DictionaryQueryResponse.self, from: data)

                guard currentToken == self.cancellationToken else {
                    self.isLoadingPage = false
                    return
                }

                let fetchedDictionaries = response.data.items.map { $0.toDictionaryItem() }

                await MainActor.run {
                    self.processFetchedDictionaries(fetchedDictionaries, lastEvaluated: response.last_evaluated)
                    self.isLoadingPage = false
                }
            } catch {
                guard currentToken == self.cancellationToken else {
                    self.isLoadingPage = false
                    return
                }

                let appError = AppErrorModel(errorType: .api, errorMessage: error.localizedDescription, additionalInfo: nil)
                ErrorManager.shared.setError(appError: appError, frame: frame, source: .dictionariesRemoteGet)

                await MainActor.run {
                    self.isLoadingPage = false
                }
            }
        }
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
