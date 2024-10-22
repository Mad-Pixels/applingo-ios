import Foundation
import Combine
import GRDB

final class TabWordsViewModel: ObservableObject {
    @Published var dictionaries: [DictionaryItem] = []
    @Published var words: [WordItem] = []
    @Published var searchText: String = ""
    
    private var cancellable: AnyCancellable?
    private var isActiveTab: Bool = false
    
    private let windowSize: Int = 50
    private let itemsPerPage: Int = 20
    private var totalFetchedWords: [WordItem] = []
    private var currentWindowStart: Int = 0
    private var hasMorePagesUp = true
    private var hasMorePagesDown = true
    var isLoadingPage = false
    
    init() {
        cancellable = NotificationCenter.default
            .publisher(for: .didSelectWordsTab)
            .sink { [weak self] _ in
                self?.isActiveTab = true
                Logger.debug("[TabWordsViewModel]: Words tab selected")
                self?.resetPagination()
                self?.getWords(direction: .down) // Загрузка вниз при старте
            }
    }
    
    deinit {
        cancellable?.cancel()
    }
    
    // Сброс пагинации при открытии вкладки или обновлении данных
    func resetPagination() {
            hasMorePagesDown = true
            hasMorePagesUp = true
            words.removeAll()
            totalFetchedWords.removeAll()
        }
    
    
    
    private func updateVisibleWindow(fetchedWords: [WordItem], direction: LoadDirection) {
            if direction == .down {
                words.append(contentsOf: fetchedWords)
            } else if direction == .up {
                words.insert(contentsOf: fetchedWords.reversed(), at: 0)
            }
            // Обновление окна с учётом текущей позиции
            print("🎯 Окно обновлено: \(currentWindowStart)..<\(words.count) из \(words.count)")
        }
        
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
    
    
    // Обработка ошибок
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
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func getWords(direction: LoadDirection = .down) {
            guard !isLoadingPage else {
                print("⚠️ Уже идёт загрузка")
                return
            }
            
            isLoadingPage = true

            // Выполняем SQL-запрос с корректными условиями
            performDatabaseOperation(
                { db in
                    let activeDictionaries = try DictionaryItem.fetchActiveDictionaries(in: db)
                    guard let selectedDictionary = activeDictionaries.first else {
                        return [WordItem]()
                    }

                    var query = """
                        SELECT *, '\(selectedDictionary.tableName)' AS tableName 
                        FROM \(selectedDictionary.tableName)
                    """
                    var arguments: [DatabaseValueConvertible] = []

                    switch direction {
                    case .down:
                        if let lastId = self.words.last?.id {
                            query += " WHERE id < ?"
                            arguments.append(lastId)
                        }
                        query += " ORDER BY id DESC LIMIT ?"
                        arguments.append(self.itemsPerPage)
                    case .up:
                        if let firstId = self.words.first?.id {
                            query += " WHERE id > ?"
                            arguments.append(firstId)
                        }
                        query += " ORDER BY id ASC LIMIT ?"
                        arguments.append(self.itemsPerPage)
                    }

                    return try SQLRequest<WordItem>(sql: query, arguments: StatementArguments(arguments)).fetchAll(db)
                },
                successHandler: { [weak self] (fetchedWords: [WordItem]) in
                    guard let self = self else { return }
                    
                    // Если ничего не загрузилось, выключаем флаг "hasMorePages"
                    if fetchedWords.isEmpty {
                        if direction == .down {
                            self.hasMorePagesDown = false
                        } else {
                            self.hasMorePagesUp = false
                        }
                        self.isLoadingPage = false
                        print("⚠️ Нет больше данных для загрузки.")
                        return
                    }

                    self.updateVisibleWindow(fetchedWords: fetchedWords, direction: direction)
                    self.isLoadingPage = false
                    print("📦 Загружено \(fetchedWords.count) слов")
                },
                errorHandler: { [weak self] error in
                    guard let self = self else { return }
                    self.isLoadingPage = false
                    print("❌ Ошибка при загрузке слов: \(error)")
                }
            )
        }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

    func loadMoreWordsIfNeeded(currentItem word: WordItem?) {
            guard let word = word,
                  let currentIndex = words.firstIndex(where: { $0.id == word.id }) else {
                return
            }

            if currentIndex <= 5 && !isLoadingPage && hasMorePagesUp {
                print("⬆️ Загрузка вверх от текущего id: \(word.id)")
                getWords(direction: .up)
            }

            if currentIndex >= words.count - 5 && !isLoadingPage && hasMorePagesDown {
                print("⬇️ Загрузка вниз от текущего id: \(word.id)")
                getWords(direction: .down)
            }
        }

    
    
    
    
    
    
    
    
    
    
    
    // CRUD операции для работы с базой данных
    func saveWord(_ word: WordItem, completion: @escaping (Result<Void, Error>) -> Void) {
        Logger.debug("[TabWordsViewModel]: Saving word to database...")
        
        performDatabaseOperation(
            { db in
                var newWord = word
                try newWord.insert(db)
            },
            successHandler: { [weak self] _ in
                self?.words.insert(word, at: 0)
                Logger.debug("[TabWordsViewModel]: Word saved successfully")
                completion(.success(()))
            },
            errorHandler: { [weak self] error in
                guard let self = self else { return }
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
    
    func updateWord(_ word: WordItem, completion: @escaping (Result<Void, Error>) -> Void) {
        Logger.debug("[TabWordsViewModel]: Updating word in database...")
        
        performDatabaseOperation(
            { db in
                try WordItem.updateWord(in: db, word: word)
            },
            successHandler: { [weak self] _ in
                if let index = self?.words.firstIndex(where: { $0.id == word.id && $0.tableName == word.tableName }) {
                    self?.words[index] = word
                    Logger.debug("[TabWordsViewModel]: Word updated successfully")
                    completion(.success(()))
                } else {
                    completion(.failure(AppError(errorType: .unknown, errorMessage: "Word not found in local list",additionalInfo: nil)))
                }
            },
            errorHandler: { [weak self] error in
                guard let self = self else { return }
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
    
    func deleteWord(_ word: WordItem) {
        Logger.debug("[TabWordsViewModel]: Deleting word with ID \(word.id)")
        
        performDatabaseOperation(
            { db in
                try WordItem.deleteWord(in: db, fromTable: word.tableName, wordID: word.id)
            },
            successHandler: { [weak self] _ in
                if let index = self?.words.firstIndex(where: { $0.id == word.id && $0.tableName == word.tableName }) {
                    self?.words.remove(at: index)
                    Logger.debug("[TabWordsViewModel]: Word with ID \(word.id) was deleted successfully")
                }
            },
            errorHandler: { [weak self] error in
                guard let self = self else { return }
                self.handleError(
                    error: error,
                    source: .wordDelete,
                    message: "Failed to delete word from database",
                    tab: .words
                )
            }
        )
    }
    
    func getDictionaries(completion: @escaping (Result<Void, Error>) -> Void) {
        Logger.debug("[TabWordsViewModel]: Fetching dictionaries...")
        
        performDatabaseOperation(
            { db in
                return try DictionaryItem.fetchAll(db)
            },
            successHandler: { [weak self] fetchedDictionaries in
                self?.dictionaries = fetchedDictionaries
                Logger.debug("[TabWordsViewModel]: Dictionaries fetched successfully")
                completion(.success(()))
            },
            errorHandler: { [weak self] error in
                guard let self = self else { return }
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

enum LoadDirection {
    case up
    case down
}

