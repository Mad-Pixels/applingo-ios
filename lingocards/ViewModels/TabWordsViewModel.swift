import Foundation
import Combine
import GRDB

final class TabWordsViewModel: ObservableObject {
    @Published var dictionaries: [DictionaryItem] = []
    
    private var cancellable: AnyCancellable?
    private var isActiveTab: Bool = false
    
    init() {
        cancellable = NotificationCenter.default
            .publisher(for: .didSelectWordsTab)
            .sink { [weak self] _ in
                self?.isActiveTab = true
                Logger.debug("[TabWordsViewModel]: Выбрана вкладка 'Слова'")
            }
    }
    
    deinit {
        cancellable?.cancel()
    }
    
    // Сохранение слова в базу данных
    func saveWord(_ word: WordItem, completion: @escaping (Result<Void, Error>) -> Void) {
        Logger.debug("[TabWordsViewModel]: Сохранение слова в базу данных...")
        
        performDatabaseOperation(
            { db in
                var newWord = word
                try newWord.insert(db)
            },
            successHandler: { _ in
                Logger.debug("[TabWordsViewModel]: Слово успешно сохранено")
                completion(.success(()))
            },
            errorHandler: { [weak self] error in
                guard let self = self else { return }
                self.handleError(
                    error: error,
                    source: .wordSave,
                    message: "Не удалось сохранить слово в базу данных",
                    tab: .words
                )
                completion(.failure(error))
            }
        )
    }
    
    // Обновление слова в базе данных
    func updateWord(_ word: WordItem, completion: @escaping (Result<Void, Error>) -> Void) {
        Logger.debug("[TabWordsViewModel]: Обновление слова в базе данных...")
        
        performDatabaseOperation(
            { db in
                try WordItem.updateWord(in: db, word: word)
            },
            successHandler: { _ in
                Logger.debug("[TabWordsViewModel]: Слово успешно обновлено")
                completion(.success(()))
            },
            errorHandler: { [weak self] error in
                guard let self = self else { return }
                self.handleError(
                    error: error,
                    source: .wordUpdate,
                    message: "Не удалось обновить слово в базе данных",
                    tab: .words
                )
                completion(.failure(error))
            }
        )
    }
    
    // Удаление слова из базы данных
    func deleteWord(_ word: WordItem, completion: @escaping (Result<Void, Error>) -> Void) {
        Logger.debug("[TabWordsViewModel]: Удаление слова с ID \(word.id)")
        
        performDatabaseOperation(
            { db in
                try WordItem.deleteWord(in: db, fromTable: word.tableName, wordID: word.id)
            },
            successHandler: { _ in
                Logger.debug("[TabWordsViewModel]: Слово с ID \(word.id) успешно удалено")
                completion(.success(()))
            },
            errorHandler: { [weak self] error in
                guard let self = self else { return }
                self.handleError(
                    error: error,
                    source: .wordDelete,
                    message: "Не удалось удалить слово из базы данных",
                    tab: .words
                )
                completion(.failure(error))
            }
        )
    }
    
    // Получение словарей из базы данных
    func getDictionaries(completion: @escaping (Result<Void, Error>) -> Void) {
        Logger.debug("[TabWordsViewModel]: Получение словарей...")
        
        performDatabaseOperation(
            { db in
                return try DictionaryItem.fetchAll(db)
            },
            successHandler: { [weak self] fetchedDictionaries in
                self?.dictionaries = fetchedDictionaries
                Logger.debug("[TabWordsViewModel]: Словари успешно получены")
                completion(.success(()))
            },
            errorHandler: { [weak self] error in
                guard let self = self else { return }
                self.handleError(
                    error: error,
                    source: .dictionariesGet,
                    message: "Не удалось получить словари из базы данных",
                    tab: .words
                )
                completion(.failure(error))
            }
        )
    }
    
    // Хелпер для операций с базой данных
    private func performDatabaseOperation<T>(
        _ operation: @escaping (Database) throws -> T,
        successHandler: @escaping (T) -> Void,
        errorHandler: @escaping (Error) -> Void
    ) {
        guard DatabaseManager.shared.isConnected else {
            let error = AppError(
                errorType: .database,
                errorMessage: "База данных не подключена",
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
}
