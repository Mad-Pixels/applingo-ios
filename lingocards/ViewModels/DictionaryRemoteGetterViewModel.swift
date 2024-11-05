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
    private let repository: APIRepositoryProtocol
    private var cancellationToken = UUID()

    init(repository: APIRepositoryProtocol) {
        self.repository = repository
    }

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
                return try await self.repository.getDictionaries()
            },
            successHandler: { [weak self] fetchedDictionaries in
                guard let self = self else { return }
                guard currentToken == self.cancellationToken else {
                    self.isLoadingPage = false
                    return
                }
                self.processFetchedDictionaries(fetchedDictionaries)
                self.isLoadingPage = false
            },
            source: .dictionariesRemoteGet,
            frame: frame,
            message: "Failed to load remote dictionaries",
            additionalInfo: ["query": "\(queryRequest?.name ?? "")"],
            completion: { [weak self] result in
                self?.isLoadingPage = false
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
    
    private func processFetchedDictionaries(_ fetchedDictionaries: [DictionaryItemModel]) {
        if fetchedDictionaries.isEmpty {
            hasMorePages = false
        } else {
            dictionaries.append(contentsOf: fetchedDictionaries)
            self.lastEvaluated = fetchedDictionaries.last?.id.map { "\($0)" }
            hasMorePages = (lastEvaluated != nil)
        }
    }
}
