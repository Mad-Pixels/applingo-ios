import Foundation
import Combine

final class DictionaryLocalGetterViewModel: BaseDatabaseViewModel {
    @Published var dictionaries: [DictionaryItem] = []
    
    private let repository: DictionaryRepositoryProtocol
    private var isLoadingPage = false
    private var hasMorePages = true

    init(repository: DictionaryRepositoryProtocol) {
        self.repository = repository
        super.init()
    }

    func resetPagination() {
        dictionaries.removeAll()
        isLoadingPage = false
        hasMorePages = true
        get()
    }

    func get() {
        guard !isLoadingPage, hasMorePages else { return }
        isLoadingPage = true

        performDatabaseOperation(
            { try self.repository.fetch() },
            successHandler: { [weak self] fetchedDictionaries in
                self?.processFetchedDictionaries(fetchedDictionaries)
                self?.isLoadingPage = false
            },
            errorSource: .dictionariesGet,
            errorMessage: "Failed to fetch dictionaries",
            tab: .dictionaries,
            completion: { [weak self] result in
                if case .failure = result {
                    self?.isLoadingPage = false
                }
            }
        )
    }
    
    private func processFetchedDictionaries(_ fetchedDictionaries: [DictionaryItem]) {
        if fetchedDictionaries.isEmpty {
            hasMorePages = false
        } else {
            dictionaries.append(contentsOf: fetchedDictionaries)
        }
    }

    func clear() {
        dictionaries = []
    }
}
