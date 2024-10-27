import Foundation
import Combine

final class WordsLocalGetterViewModel: BaseDatabaseViewModel {
    @Published var words: [WordItem] = []
    @Published var searchText: String = "" {
        didSet {
            setupSearchTextSubscription()
        }
    }
    
    private let repository: WordRepositoryProtocol
    private let itemsPerPage: Int = 50
    
    private var isLoadingPage = false
    private var hasMorePages = true
    private var cancellables = Set<AnyCancellable>()
    
    init(repository: WordRepositoryProtocol) {
        self.repository = repository
        super.init()
        //resetPagination()
    }
    
    private func setupSearchTextSubscription() {
        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                self?.resetPagination()
            }
            .store(in: &cancellables)
    }

    func resetPagination() {
        words.removeAll()
        isLoadingPage = false
        hasMorePages = true
        get()
    }

    func get() {
        guard !isLoadingPage, hasMorePages else { return }
        isLoadingPage = true

        performDatabaseOperation(
            { try self.repository.fetch(searchText: self.searchText, lastItem: self.words.last, limit: self.itemsPerPage) },
            successHandler: { [weak self] fetchedWords in
                self?.processFetchedWords(fetchedWords)
                self?.isLoadingPage = false
            },
            errorSource: .wordsGet,
            errorMessage: "Failed to fetch words",
            tab: .words,
            completion: { [weak self] result in
                if case .failure = result {
                    self?.isLoadingPage = false
                }
            }
        )
    }
    
    func loadMoreWordsIfNeeded(currentItem word: WordItem?) {
        guard
            let word = word,
            let index = words.firstIndex(where: { $0.id == word.id }),
            index >= words.count - 5,
            hasMorePages,
            !isLoadingPage
        else { return }
        get()
    }

    private func processFetchedWords(_ fetchedWords: [WordItem]) {
        if fetchedWords.isEmpty {
            hasMorePages = false
        } else {
            words.append(contentsOf: fetchedWords)
        }
    }

    func clear() {
        words = []
    }
}
