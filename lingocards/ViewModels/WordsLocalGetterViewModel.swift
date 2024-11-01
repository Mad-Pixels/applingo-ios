import Foundation
import Combine

final class WordsLocalGetterViewModel: BaseDatabaseViewModel {
    @Published var words: [WordItem] = []
    @Published var isLoadingPage = false
    @Published var searchText: String = "" {
        didSet {
            if searchText != oldValue {
                resetPagination()
            }
        }
    }

    private var cancellables = Set<AnyCancellable>()
    private let repository: WordRepositoryProtocol
    private var cancellationToken = UUID()
    private let itemsPerPage: Int = 50
    private var hasMorePages = true
    private var currentPage = 0

    init(repository: WordRepositoryProtocol) {
        self.repository = repository
        super.init()
    }

    func resetPagination() {
        words.removeAll()
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
            { try self.repository.fetch(
                searchText: self.searchText,
                offset: self.currentPage * self.itemsPerPage,
                limit: self.itemsPerPage
            ) },
            successHandler: { [weak self] fetchedWords in
                guard let self = self else { return }
                guard currentToken == self.cancellationToken else {
                    self.isLoadingPage = false
                    return
                }
                self.processFetchedWords(fetchedWords)
                self.isLoadingPage = false
            },
            errorSource: .wordsGet,
            errorMessage: "Failed load words",
            tab: .words,
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

    func loadMoreWordsIfNeeded(currentItem word: WordItem?) {
        guard
            let word = word,
            let index = words.firstIndex(where: { $0.id == word.id })
        else { return }
        
        if index >= words.count - 5 && hasMorePages && !isLoadingPage {
            get()
        }
    }

    private func processFetchedWords(_ fetchedWords: [WordItem]) {
        if fetchedWords.isEmpty {
            hasMorePages = false
        } else {
            currentPage += 1
            words.append(contentsOf: fetchedWords)
        }
    }

    func clear() {
        words = []
    }
}
