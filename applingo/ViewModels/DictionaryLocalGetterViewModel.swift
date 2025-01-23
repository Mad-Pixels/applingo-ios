import Foundation
import Combine

final class DictionaryLocalGetterViewModel: BaseDatabaseViewModel {
    @Published var dictionaries: [DictionaryItemModel] = []
    @Published var isLoadingPage = false
    @Published var searchText: String = "" {
        didSet {
            if searchText != oldValue {
                resetPagination()
            }
        }
    }

    private var cancellables = Set<AnyCancellable>()
    private let dictionaryRepository: DictionaryRepositoryProtocol
    private var cancellationToken = UUID()
    private var frame: AppFrameModel = .main
    private let itemsPerPage: Int = 50
    private var hasMorePages = true
    private var currentPage = 0

    override init() {
        if let dbQueue = AppDatabase.shared.databaseQueue {
            self.dictionaryRepository = RepositoryDictionary(dbQueue: dbQueue)
        } else {
            fatalError("Database is not connected")
        }
        super.init()
    }

    func resetPagination() {
        dictionaries.removeAll()
        currentPage = 0
        hasMorePages = true
        isLoadingPage = false
        cancellationToken = UUID()
        get()
    }

    func get() {
        guard !isLoadingPage, hasMorePages else {
            return
        }
        let currentToken = cancellationToken
        isLoadingPage = true

        performDatabaseOperation(
            { try self.dictionaryRepository.fetch(
                searchText: self.searchText,
                offset: self.currentPage * self.itemsPerPage,
                limit: self.itemsPerPage
            ) },
            successHandler: { [weak self] fetchedDictionaries in
                guard let self = self else { return }
                guard currentToken == self.cancellationToken else {
                    self.isLoadingPage = false
                    return
                }
                self.processFetchedDictionaries(fetchedDictionaries)
                self.isLoadingPage = false
            },
            source: .dictionariesGet,
            frame: frame,
            message: "Failed to load dictionaries",
            additionalInfo: ["searchText": searchText],
            completion: { [weak self] result in
                guard let self = self else { return }
                guard currentToken == self.cancellationToken else {
                    self.isLoadingPage = false
                    return
                }
                if case .failure = result {
                    self.isLoadingPage = false
                }
            }
        )
    }
    
    func loadMoreDictionariesIfNeeded(currentItem: DictionaryItemModel?) {
        guard
            let dictionary = currentItem,
            let index = dictionaries.firstIndex(where: { $0.id == dictionary.id }),
            index >= dictionaries.count - 5,
            hasMorePages,
            !isLoadingPage
        else { return }
        get()
    }

    func clear() {
        dictionaries = []
    }
    
    func setFrame(_ newFrame: AppFrameModel) {
        self.frame = newFrame
    }
    
    private func processFetchedDictionaries(_ fetchedDictionaries: [DictionaryItemModel]) {
        if fetchedDictionaries.isEmpty {
            hasMorePages = false
        } else {
            currentPage += 1
            dictionaries.append(contentsOf: fetchedDictionaries)
        }
    }
}
