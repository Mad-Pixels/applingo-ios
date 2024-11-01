import Foundation
import Combine

final class DictionaryLocalGetterViewModel: BaseDatabaseViewModel {
    @Published var dictionaries: [DictionaryItem] = []
    @Published var searchText: String = "" {
        didSet {
            filterDictionaries()
        }
    }
    
    var isLoadingPage = false
    
    private var hasMorePages = true
    private var allDictionaries: [DictionaryItem] = []
    private let repository: DictionaryRepositoryProtocol

    init(repository: DictionaryRepositoryProtocol) {
        self.repository = repository
        super.init()
        get()
    }

    func resetPagination() {
        dictionaries.removeAll()
        allDictionaries.removeAll()
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
            allDictionaries.append(contentsOf: fetchedDictionaries)
            filterDictionaries()
        }
    }
    
    func loadMoreDictionariesIfNeeded(currentItem: DictionaryItem?) {
        guard let currentItem = currentItem else { return }
        let thresholdIndex = dictionaries.index(dictionaries.endIndex, offsetBy: -5)
        
        if dictionaries.firstIndex(where: { $0.id == currentItem.id }) == thresholdIndex {
            get()
        }
    }

    private func filterDictionaries() {
        if searchText.isEmpty {
            dictionaries = allDictionaries
        } else {
            dictionaries = allDictionaries.filter { dictionary in
                dictionary.displayName.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    func clear() {
        dictionaries = []
        allDictionaries = []
    }
}
