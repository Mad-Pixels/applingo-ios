import Foundation
import Combine
import GRDB

final class TabWordsViewModel: ObservableObject {
    @Published var dictionaries: [DictionaryItem] = []
    @Published var words: [WordItem] = []
    @Published var searchText: String = ""
    
    private var cancellable: AnyCancellable?
    private var isActiveTab: Bool = false  // Флаг активности вкладки
    
    // Параметры пагинации
    private var currentPage: Int = 1
    private let itemsPerPage: Int = 30
    var isLoadingPage: Bool = false
    private var hasMorePages: Bool = true
    
    init() {
        // Подписка на уведомление при выборе вкладки Words
        cancellable = NotificationCenter.default
            .publisher(for: .didSelectWordsTab)
            .sink { [weak self] _ in
                self?.isActiveTab = true  // Устанавливаем флаг активности
                Logger.debug("[TabWordsViewModel]: Words tab selected")
                self?.resetPagination()
                self?.getWords()
            }
    }
    
    deinit {
        cancellable?.cancel()
    }
    
    // Метод для сброса параметров пагинации
    func resetPagination() {
        currentPage = 1
        hasMorePages = true
        words.removeAll()
    }
    
    // Основной метод получения данных
    func getWords() {
        guard !isLoadingPage, hasMorePages else {
            return
        }
        
        Logger.debug("[TabWordsViewModel]: Fetching words from database...")
        isLoadingPage = true
        
        guard DatabaseManager.shared.isConnected else {
            let error = AppError(
                errorType: .database,
                errorMessage: "Database is not connected",
                additionalInfo: nil
            )
            ErrorManager.shared.setError(
                appError: error,
                tab: .words,
                source: .wordsGet
            )
            isLoadingPage = false
            return
        }
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            do {
                var fetchedWords: [WordItem] = []
                try DatabaseManager.shared.databaseQueue?.read { db in
                    // Получаем активные словари
                    let activeDictionaries = try DictionaryItem.fetchActiveDictionaries(in: db)
                    
                    // Если нет активных словарей
                    if activeDictionaries.isEmpty {
                        DispatchQueue.main.async {
                            self.hasMorePages = false
                            self.isLoadingPage = false
                            self.words = []
                        }
                        return
                    }
                    
                    // Обрабатываем слова из всех активных словарей
                    for dictionary in activeDictionaries {
                        let pageWords = try WordItem.fetchWords(
                            in: db,
                            fromTable: dictionary.tableName,
                            searchText: self.searchText,
                            itemsPerPage: self.itemsPerPage,
                            offset: (self.currentPage - 1) * self.itemsPerPage
                        )
                        fetchedWords.append(contentsOf: pageWords)
                    }
                    
                    // Проверяем, если на текущей странице меньше элементов, чем itemsPerPage
                    if fetchedWords.count < self.itemsPerPage {
                        self.hasMorePages = false
                    }
                }
                
                DispatchQueue.main.async {
                    self.words.append(contentsOf: fetchedWords)
                    self.currentPage += 1
                    self.isLoadingPage = false
                    ErrorManager.shared.clearError(for: .wordsGet)
                    Logger.debug("[TabWordsViewModel]: Words data successfully fetched from database")
                }
            } catch {
                DispatchQueue.main.async {
                    self.isLoadingPage = false
                    self.hasMorePages = false
                    Logger.debug("[TabWordsViewModel]: Failed to fetch words from database: \(error)")
                    let appError = AppError(
                        errorType: .database,
                        errorMessage: "Failed to fetch data from database",
                        additionalInfo: ["error": "\(error)"]
                    )
                    ErrorManager.shared.setError(
                        appError: appError,
                        tab: .words,
                        source: .wordsGet
                    )
                }
            }
        }
    }
    
    // Метод для загрузки следующей страницы
    func loadMoreWordsIfNeeded(currentItem word: WordItem?) {
        guard let word = word else {
            return
        }
        
        let thresholdIndex = words.index(words.endIndex, offsetBy: -5)
        if words.firstIndex(where: { $0.id == word.id }) == thresholdIndex {
            getWords()
        }
    }
    
    // Метод для удаления слова
    func deleteWord(_ word: WordItem) {
        Logger.debug("[TabWordsViewModel]: Deleting word with ID \(word.id)")
        
        guard DatabaseManager.shared.isConnected else {
            let error = AppError(
                errorType: .database,
                errorMessage: "Database is not connected",
                additionalInfo: nil
            )
            ErrorManager.shared.setError(
                appError: error,
                tab: .words,
                source: .wordDelete
            )
            return
        }
        
        do {
            try DatabaseManager.shared.databaseQueue?.write { db in
                try WordItem.deleteWord(in: db, fromTable: word.tableName, wordID: word.id)
            }
            
            // Удаляем слово из локального массива
            if let index = words.firstIndex(where: { $0.id == word.id && $0.tableName == word.tableName }) {
                words.remove(at: index)
                Logger.debug("[TabWordsViewModel]: Word with ID \(word.id) was deleted successfully")
            }
            
            ErrorManager.shared.clearError(for: .wordDelete)
        } catch {
            Logger.debug("[TabWordsViewModel]: Failed to delete word from database: \(error)")
            let appError = AppError(
                errorType: .database,
                errorMessage: "Failed to delete word from database",
                additionalInfo: ["error": "\(error)"]
            )
            ErrorManager.shared.setError(
                appError: appError,
                tab: .words,
                source: .wordDelete
            )
        }
    }
    
    // Метод для обновления слова
    func updateWord(_ word: WordItem, completion: @escaping (Result<Void, Error>) -> Void) {
        Logger.debug("[TabWordsViewModel]: Updating word in database...")
        
        guard DatabaseManager.shared.isConnected else {
            let error = AppError(
                errorType: .database,
                errorMessage: "Database is not connected",
                additionalInfo: nil
            )
            completion(.failure(error))
            return
        }
        
        do {
            try DatabaseManager.shared.databaseQueue?.write { db in
                try WordItem.updateWord(in: db, word: word)
            }
            
            // Обновляем слово в локальном массиве
            if let index = words.firstIndex(where: { $0.id == word.id && $0.tableName == word.tableName }) {
                words[index] = word
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
        } catch {
            Logger.debug("[TabWordsViewModel]: Failed to update word in database: \(error)")
            let appError = AppError(
                errorType: .database,
                errorMessage: "Failed to update word in database",
                additionalInfo: ["error": "\(error)"]
            )
            completion(.failure(appError))
        }
    }
    
    // Метод для сохранения нового слова
    func saveWord(_ word: WordItem, completion: @escaping (Result<Void, Error>) -> Void) {
        Logger.debug("[TabWordsViewModel]: Saving word to database...")
        
        guard DatabaseManager.shared.isConnected else {
            let error = AppError(
                errorType: .database,
                errorMessage: "Database is not connected",
                additionalInfo: nil
            )
            completion(.failure(error))
            return
        }
        
        do {
            try DatabaseManager.shared.databaseQueue?.write { db in
                var newWord = word
                try newWord.insert(db)
            }
            
            // Добавляем слово в локальный массив
            words.insert(word, at: 0)
            Logger.debug("[TabWordsViewModel]: Word saved successfully")
            completion(.success(()))
        } catch {
            Logger.debug("[TabWordsViewModel]: Failed to save word to database: \(error)")
            let appError = AppError(
                errorType: .database,
                errorMessage: "Failed to save word to database",
                additionalInfo: ["error": "\(error)"]
            )
            completion(.failure(appError))
        }
    }
    
    // Метод для получения списка словарей (для добавления слова)
    func getDictionaries(completion: @escaping (Result<Void, Error>) -> Void) {
        Logger.debug("[TabWordsViewModel]: Fetching dictionaries...")
        
        guard DatabaseManager.shared.isConnected else {
            let error = AppError(
                errorType: .database,
                errorMessage: "Database is not connected",
                additionalInfo: nil
            )
            completion(.failure(error))
            return
        }
        
        do {
            try DatabaseManager.shared.databaseQueue?.read { db in
                let fetchedDictionaries = try DictionaryItem.fetchAll(db)
                DispatchQueue.main.async {
                    self.dictionaries = fetchedDictionaries
                    Logger.debug("[TabWordsViewModel]: Dictionaries fetched successfully")
                    completion(.success(()))
                }
            }
        } catch {
            Logger.debug("[TabWordsViewModel]: Failed to fetch dictionaries from database: \(error)")
            let appError = AppError(
                errorType: .database,
                errorMessage: "Failed to fetch dictionaries from database",
                additionalInfo: ["error": "\(error)"]
            )
            completion(.failure(appError))
        }
    }
}
