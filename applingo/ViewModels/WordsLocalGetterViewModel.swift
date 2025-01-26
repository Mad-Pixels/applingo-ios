import Foundation
import Combine

final class WordsLocalGetterViewModel: BaseDatabaseViewModel {
    @Published var words: [DatabaseModelWord] = []
    @Published var isLoadingPage = false
    @Published var searchText: String = "" {
        didSet {
            if searchText != oldValue {
                resetPagination()
            }
        }
    }

    private var cancellables = Set<AnyCancellable>()
    private let wordRepository: RepositoryWord
    private var cancellationToken = UUID()
    private var frame: AppFrameModel = .main
    private let itemsPerPage: Int = 50
    private var hasMorePages = true
    private var currentPage = 0

    override init() {
        guard let dbQueue = AppDatabase.shared.databaseQueue else {
            fatalError("Database is not connected")
        }

        self.wordRepository = RepositoryWord(dbQueue: dbQueue)
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
            { try self.wordRepository.fetch(
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
            source: .wordsGet,
            frame: frame,
            message: "Failed to load words",
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

    func loadMoreWordsIfNeeded(currentItem word: DatabaseModelWord?) {
        guard
            let word = word,
            let index = words.firstIndex(where: { $0.id == word.id }),
            index >= words.count - 5,
            hasMorePages,
            !isLoadingPage
        else { return }
        get()
    }

    func clear() {
        words = []
    }

    func setFrame(_ newFrame: AppFrameModel) {
        self.frame = newFrame
    }

    private func processFetchedWords(_ fetchedWords: [DatabaseModelWord]) {
        if fetchedWords.isEmpty {
            hasMorePages = false
        } else {
            currentPage += 1
            words.append(contentsOf: fetchedWords)
        }
    }
}
