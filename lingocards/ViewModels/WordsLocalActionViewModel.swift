import Foundation
import Combine
import GRDB

final class WordsLocalActionViewModel: ObservableObject {
    @Published var dictionaries: [DictionaryItem] = []
    
    // Сохранение слова в базу данных
    func saveWord(_ word: WordItem, completion: @escaping (Result<Void, Error>) -> Void) {
        performDatabaseOperation(
            { db in
                var newWord = word
                try newWord.insert(db)
            },
            successHandler: { _ in
                print("[WordsActionViewModel]: Слово успешно сохранено")
                completion(.success(()))
            },
            errorHandler: { error in
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
        performDatabaseOperation(
            { db in
                try word.update(db)
            },
            successHandler: { _ in
                print("[WordsActionViewModel]: Слово успешно обновлено")
                completion(.success(()))
            },
            errorHandler: { error in
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
        performDatabaseOperation(
            { db in
                try word.delete(db)
            },
            successHandler: { _ in
                print("[WordsActionViewModel]: Слово с ID \(word.id) успешно удалено")
                completion(.success(()))
            },
            errorHandler: { error in
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
    
    // Получение списка словарей из базы данных
    func getDictionaries(completion: @escaping (Result<Void, Error>) -> Void) {
        performDatabaseOperation(
            { db in
                return try DictionaryItem.fetchAll(db)
            },
            successHandler: { fetchedDictionaries in
                self.dictionaries = fetchedDictionaries
                print("[WordsActionViewModel]: Словари успешно получены")
                completion(.success(()))
            },
            errorHandler: { error in
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
                let result = try DatabaseManager.shared.databaseQueue?.write { db in
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
        print("[WordsActionViewModel]: \(message): \(error)")
        let appError = AppError(
            errorType: .database,
            errorMessage: message,
            additionalInfo: ["error": "\(error)"]
        )
        ErrorManager.shared.setError(appError: appError, tab: tab, source: source)
    }
}
