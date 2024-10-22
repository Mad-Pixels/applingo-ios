import Foundation
import Combine
import GRDB

final class TabWordsViewModel: ObservableObject {
    @Published var dictionaries: [DictionaryItem] = []
    @Published var words: [WordItem] = []
    @Published var searchText: String = ""
    
    private var cancellable: AnyCancellable?
    private var isActiveTab: Bool = false
    
    private var currentPage: Int = 1
    private let itemsPerPage: Int = 30
    var isLoadingPage: Bool = false
    private var hasMorePages: Bool = true
    
    init() {
        cancellable = NotificationCenter.default
            .publisher(for: .didSelectWordsTab)
            .sink { [weak self] _ in
                self?.isActiveTab = true
                Logger.debug("[TabWordsViewModel]: Words tab selected")
                self?.resetPagination()
                self?.getWords()
            }
    }
    
    deinit {
        cancellable?.cancel()
    }
    
    func resetPagination() {
        currentPage = 1
        hasMorePages = true
        words.removeAll()
    }
    
    // Универсальная функция для работы с базой данных
    private func performDatabaseOperation<T>(
        _ operation: @escaping (Database) throws -> T,
        successHandler: @escaping (T) -> Void,
        errorHandler: @escaping (Error) -> Void
    ) {
        guard DatabaseManager.shared.isConnected else {
            let error = AppError(
                errorType: .database,
                errorMessage: "Database is not connected",
                additionalInfo: nil
            )
            errorHandler(error)
            return
        }

        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let result = try DatabaseManager.shared.databaseQueue?.read { db in
                    try operation(db)
                }
                DispatchQueue.main.async {
                    if let result = result {
                        successHandler(result)
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    errorHandler(error)
                }
            }
        }
    }
    
    // Универсальный обработчик ошибок
    private func handleError(
        error: Error,
        source: ErrorSource,
        message: String,
        tab: AppTab
    ) {
        Logger.debug("[TabWordsViewModel]: \(message): \(error)")
        let appError = AppError(
            errorType: .database,
            errorMessage: message,
            additionalInfo: ["error": "\(error)"]
        )
        ErrorManager.shared.setError(appError: appError, tab: tab, source: source)
    }

    func getWords() {
        guard !isLoadingPage, hasMorePages else { return }
        
        isLoadingPage = true
        Logger.debug("[TabWordsViewModel]: Fetching words from database...")
        
        performDatabaseOperation(
            { db in
                // Получаем активные словари
                let activeDictionaries = try DictionaryItem.fetchActiveDictionaries(in: db)
                
                // Если нет активных словарей, возвращаем пустой результат
                guard !activeDictionaries.isEmpty else {
                    return [WordItem]()
                }
                
                // Собираем список имён таблиц
                let tableNames = activeDictionaries.map { $0.tableName }
                
                // Создаём подзапрос для объединения данных из всех таблиц
                var unionQueries: [String] = []
                var arguments: [DatabaseValueConvertible] = []
                
                for tableName in tableNames {
                    var query = "SELECT *, '\(tableName)' AS tableName FROM \(tableName)"
                    if !self.searchText.isEmpty {
                        query += " WHERE frontText LIKE ? OR backText LIKE ?"
                        let searchQuery = "%\(self.searchText)%"
                        arguments.append(contentsOf: [searchQuery, searchQuery])
                    }
                    unionQueries.append(query)
                }
                
                // Объединяем запросы через UNION ALL
                let combinedSQL = unionQueries.joined(separator: " UNION ALL ")
                
                // Оборачиваем объединённый запрос в подзапрос
                let finalSQL = """
                SELECT * FROM (\(combinedSQL)) AS combined
                ORDER BY createdAt DESC
                LIMIT ? OFFSET ?
                """
                arguments.append(contentsOf: [self.itemsPerPage, (self.currentPage - 1) * self.itemsPerPage])
                
                // Выполняем финальный SQL-запрос
                let finalRequest = SQLRequest<WordItem>(sql: finalSQL, arguments: StatementArguments(arguments))
                let fetchedWords = try finalRequest.fetchAll(db)
                
                // Проверяем, есть ли ещё страницы
                if fetchedWords.count < self.itemsPerPage {
                    self.hasMorePages = false
                }
                
                return fetchedWords
            },
            successHandler: { fetchedWords in
                self.words.append(contentsOf: fetchedWords)
                self.currentPage += 1
                self.isLoadingPage = false
                ErrorManager.shared.clearError(for: .wordsGet)
                Logger.debug("[TabWordsViewModel]: Words data successfully fetched")
            },
            errorHandler: { error in
                self.isLoadingPage = false
                self.hasMorePages = false
                self.handleError(
                    error: error,
                    source: .wordsGet,
                    message: "Failed to fetch words from database",
                    tab: .words
                )
            }
        )
    }


    
    func deleteWord(_ word: WordItem) {
        Logger.debug("[TabWordsViewModel]: Deleting word with ID \(word.id)")
        
        performDatabaseOperation(
            { db in
                try WordItem.deleteWord(in: db, fromTable: word.tableName, wordID: word.id)
            },
            successHandler: { _ in
                if let index = self.words.firstIndex(where: { $0.id == word.id && $0.tableName == word.tableName }) {
                    self.words.remove(at: index)
                    Logger.debug("[TabWordsViewModel]: Word with ID \(word.id) was deleted successfully")
                }
                ErrorManager.shared.clearError(for: .wordDelete)
            },
            errorHandler: { error in
                self.handleError(
                    error: error,
                    source: .wordDelete,
                    message: "Failed to delete word from database",
                    tab: .words
                )
            }
        )
    }

    func loadMoreWordsIfNeeded(currentItem word: WordItem?) {
        guard let word = word else { return }
        
        let thresholdIndex = words.index(words.endIndex, offsetBy: -5)
        if words.firstIndex(where: { $0.id == word.id }) == thresholdIndex {
            getWords()
        }
    }
    
    func updateWord(_ word: WordItem, completion: @escaping (Result<Void, Error>) -> Void) {
        Logger.debug("[TabWordsViewModel]: Updating word in database...")
        
        performDatabaseOperation(
            { db in
                try WordItem.updateWord(in: db, word: word)
            },
            successHandler: { _ in
                if let index = self.words.firstIndex(where: { $0.id == word.id && $0.tableName == word.tableName }) {
                    self.words[index] = word
                    Logger.debug("[TabWordsViewModel]: Word updated successfully")
                    completion(.success(()))
                } else {
                    let error = AppError(
                        errorType: .unknown,
                        errorMessage: "Word not found in local list",
                        additionalInfo: nil
                    )
                    completion(.failure(error))
                }
            },
            errorHandler: { error in
                self.handleError(
                    error: error,
                    source: .wordUpdate,
                    message: "Failed to update word in database",
                    tab: .words
                )
                completion(.failure(error))
            }
        )
    }

    func saveWord(_ word: WordItem, completion: @escaping (Result<Void, Error>) -> Void) {
        Logger.debug("[TabWordsViewModel]: Saving word to database...")
        
        performDatabaseOperation(
            { db in
                var newWord = word
                try newWord.insert(db)
            },
            successHandler: { _ in
                self.words.insert(word, at: 0)
                Logger.debug("[TabWordsViewModel]: Word saved successfully")
                completion(.success(()))
            },
            errorHandler: { error in
                self.handleError(
                    error: error,
                    source: .wordSave,
                    message: "Failed to save word to database",
                    tab: .words
                )
                completion(.failure(error))
            }
        )
    }

    func getDictionaries(completion: @escaping (Result<Void, Error>) -> Void) {
        Logger.debug("[TabWordsViewModel]: Fetching dictionaries...")
        
        performDatabaseOperation(
            { db in
                return try DictionaryItem.fetchAll(db)
            },
            successHandler: { fetchedDictionaries in
                self.dictionaries = fetchedDictionaries
                Logger.debug("[TabWordsViewModel]: Dictionaries fetched successfully")
                completion(.success(()))
            },
            errorHandler: { error in
                self.handleError(
                    error: error,
                    source: .dictionariesGet,
                    message: "Failed to fetch dictionaries from database",
                    tab: .words
                )
                completion(.failure(error))
            }
        )
    }
}
