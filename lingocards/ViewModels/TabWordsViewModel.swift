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
        currentWindowStart = 0
        hasMorePagesDown = true
        hasMorePagesUp = true  // Важно сбросить оба флага
        words.removeAll()
        totalFetchedWords.removeAll()
        print("🔄 Reset - Up: \(hasMorePagesUp), Down: \(hasMorePagesDown)")
    }
    
    var windowStart = 0
    var windowEnd = 50

    
    func updateVisibleWindow(fetchedWords: [WordItem], direction: LoadDirection) {
        if direction == .down {
            // Добавляем данные в конец массива
            totalFetchedWords.append(contentsOf: fetchedWords)
            
            // Проверяем, что есть еще страницы для загрузки
            hasMorePagesDown = fetchedWords.count == itemsPerPage
            
            // Обновляем видимое окно: убираем старые данные из начала массива
            if totalFetchedWords.count > windowSize {
                totalFetchedWords.removeFirst(fetchedWords.count)
            }
            
            // Отображаем последние windowSize слов
            let newEnd = totalFetchedWords.count
            let newStart = max(newEnd - windowSize, 0)
            words = Array(totalFetchedWords[newStart..<newEnd])
        } else if direction == .up {
            // Вставляем данные в начало массива
            totalFetchedWords.insert(contentsOf: fetchedWords, at: 0)
            
            // Проверяем, что есть еще страницы для загрузки
            hasMorePagesUp = fetchedWords.count == itemsPerPage
            
            // Удаляем старые данные из конца массива, если общий размер превышает windowSize
            if totalFetchedWords.count > windowSize {
                totalFetchedWords.removeLast(fetchedWords.count)
            }
            
            // Отображаем первые windowSize слов
            let newStart = 0
            let newEnd = min(windowSize, totalFetchedWords.count)
            words = Array(totalFetchedWords[newStart..<newEnd])
        }

        print("🎯 Updated window: \(words.count) words")
        isLoadingPage = false
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
            print("⚠️ Already loading a page, ignoring request.")
            return
        }

        isLoadingPage = true
        print("🔄 Starting getWords with direction: \(direction)")

        performDatabaseOperation(
            { db in
                let activeDictionaries = try DictionaryItem.fetchActiveDictionaries(in: db)
                guard let selectedDictionary = activeDictionaries.first else {
                    print("⚠️ No active dictionary found.")
                    return [WordItem]()
                }

                var query = """
                    SELECT *, '\(selectedDictionary.tableName)' AS tableName 
                    FROM \(selectedDictionary.tableName)
                """

                if direction == .down {
                    if self.totalFetchedWords.isEmpty {
                        print("⬇️ Loading first batch of data (no ID filter)")
                        query += " ORDER BY id DESC LIMIT \(self.itemsPerPage)"
                    } else {
                        let lastId = self.totalFetchedWords.last?.id ?? 0
                        print("⬇️ Loading after id: \(lastId)")
                        query += " WHERE id < \(lastId) ORDER BY id DESC LIMIT \(self.itemsPerPage)"
                    }
                } else if direction == .up {
                    // Устанавливаем флаг hasMorePagesUp в true всегда
                    self.hasMorePagesUp = true
                    if self.totalFetchedWords.isEmpty {
                        print("⬆️ Loading first batch of data (no ID filter)")
                        query += " ORDER BY id ASC LIMIT \(self.itemsPerPage)"
                    } else {
                        let firstId = self.totalFetchedWords.first?.id ?? 0
                        print("⬆️ Loading before id: \(firstId)")
                        query += " WHERE id > \(firstId) ORDER BY id ASC LIMIT \(self.itemsPerPage)"
                    }
                }

                print("🔍 SQL Query: \(query)")
                let fetched = try SQLRequest<WordItem>(sql: query).fetchAll(db)
                print("📊 Fetched \(fetched.count) items from DB.")
                return fetched
            },
            successHandler: { [weak self] fetchedWords in
                guard let self = self else { return }

                if direction == .down {
                    if fetchedWords.isEmpty {
                        self.hasMorePagesDown = false
                        print("⚠️ No more pages down.")
                    } else {
                        self.updateVisibleWindow(fetchedWords: fetchedWords, direction: direction)
                    }
                } else if direction == .up {
                    if fetchedWords.isEmpty {
                        self.hasMorePagesUp = true  // Всегда true, не меняем его на false
                        print("⚠️ No more pages up, but keeping hasMorePagesUp = true.")
                    } else {
                        self.updateVisibleWindow(fetchedWords: fetchedWords, direction: direction)
                    }
                }

                self.isLoadingPage = false
            },
            errorHandler: { error in
                print("❌ Error loading words: \(error)")
                self.isLoadingPage = false
            }
        )
    }


















    
    
    
 
    
    func loadMoreWordsIfNeeded(currentItem word: WordItem?) {
        guard let word = word,
              let currentIndex = words.firstIndex(where: { $0.id == word.id }) else {
            return
        }

        print("👁️ Check - index: \(currentIndex), id: \(word.id), isLoadingPage: \(isLoadingPage), hasMorePagesUp: \(hasMorePagesUp), hasMorePagesDown: \(hasMorePagesDown)")

        // Проверяем верхний порог и вызываем загрузку данных вверх, если это необходимо
        if currentIndex <= 5 && hasMorePagesUp && !isLoadingPage {
            print("⬆️ Trying to load UP")
            getWords(direction: .up)
        } else if currentIndex >= words.count - 5 && hasMorePagesDown && !isLoadingPage {
            print("⬇️ Trying to load DOWN")
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

