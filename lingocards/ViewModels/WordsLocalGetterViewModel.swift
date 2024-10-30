import Foundation
import Combine

final class WordsLocalGetterViewModel: BaseDatabaseViewModel {
    @Published var words: [WordItem] = []
    @Published var searchText: String = "" {
        didSet {
            // Только при изменении `searchText` вызываем сброс пагинации
            if searchText != oldValue {
                resetPagination()
            }
        }
    }

    private let repository: WordRepositoryProtocol
    private let itemsPerPage: Int = 50

    private var isLoadingPage = false
    private var hasMorePages = true
    private var cancellables = Set<AnyCancellable>()
    private var currentPage = 0  // Начальная страница

    init(repository: WordRepositoryProtocol) {
        self.repository = repository
        super.init()
    }

    /// Сброс состояния пагинации и очистка списка
     func resetPagination() {
        words.removeAll()         // Полностью очищаем массив при новом поиске
        currentPage = 0           // Возвращаемся к первой странице
        hasMorePages = true       // Разрешаем подгрузку страниц
        isLoadingPage = false     // Готовимся к новому запросу
        get()                     // Начинаем новый запрос
    }

    /// Запрос данных с контролем загрузки
    func get() {
        guard !isLoadingPage, hasMorePages else { return }
        isLoadingPage = true      // Начинаем загрузку и блокируем повторные вызовы

        performDatabaseOperation(
            { try self.repository.fetch(
                searchText: self.searchText,
                offset: self.currentPage * self.itemsPerPage,
                limit: self.itemsPerPage
            ) },
            successHandler: { [weak self] fetchedWords in
                guard let self = self else { return }
                self.isLoadingPage = false
                self.processFetchedWords(fetchedWords)
            },
            errorSource: .wordsGet,
            errorMessage: "Не удалось загрузить слова",
            tab: .words,
            completion: { [weak self] result in
                if case .failure = result {
                    self?.isLoadingPage = false
                }
            }
        )
    }

    /// Подгружаем дополнительные данные при необходимости
    func loadMoreWordsIfNeeded(currentItem word: WordItem?) {
        guard
            let word = word,
            let index = words.firstIndex(where: { $0.id == word.id }),
            index >= words.count - 5,
            hasMorePages,
            !isLoadingPage
        else { return }
        get()  // Подгружаем следующую страницу
    }

    /// Обработка загруженных данных
    private func processFetchedWords(_ fetchedWords: [WordItem]) {
        if fetchedWords.isEmpty {
            hasMorePages = false  // Достигли конца данных
        } else {
            currentPage += 1      // Переходим к следующей странице
            words.append(contentsOf: fetchedWords)  // Добавляем только уникальные данные
        }
    }

    func clear() {
        words = []  // Очищаем данные
    }
}
