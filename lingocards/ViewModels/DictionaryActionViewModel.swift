import Foundation
import Combine
import GRDB

final class DictionaryActionViewModel: ObservableObject {
    // Сохранение словаря в базу данных
    func saveDictionary(_ dictionary: DictionaryItem, completion: @escaping (Result<Void, Error>) -> Void) {
        performDatabaseOperation(
            { db in
                var newDictionary = dictionary
                try newDictionary.insert(db)
            },
            successHandler: { _ in
                print("[DictionaryActionViewModel]: Словарь успешно сохранён")
                completion(.success(()))
            },
            errorHandler: { error in
                self.handleError(
                    error: error,
                    source: .dictionarySave,
                    message: "Не удалось сохранить словарь в базу данных",
                    tab: .dictionaries
                )
                completion(.failure(error))
            }
        )
    }

    // Обновление словаря в базе данных
    func updateDictionary(_ dictionary: DictionaryItem, completion: @escaping (Result<Void, Error>) -> Void) {
        performDatabaseOperation(
            { db in
                try dictionary.update(db)
            },
            successHandler: { _ in
                print("[DictionaryActionViewModel]: Словарь успешно обновлён")
                completion(.success(()))
            },
            errorHandler: { error in
                self.handleError(
                    error: error,
                    source: .dictionaryUpdate,
                    message: "Не удалось обновить словарь в базе данных",
                    tab: .dictionaries
                )
                completion(.failure(error))
            }
        )
    }

    // Удаление словаря из базы данных
    func deleteDictionary(_ dictionary: DictionaryItem, completion: @escaping (Result<Void, Error>) -> Void) {
        performDatabaseOperation(
            { db in
                try dictionary.delete(db)
                let deleteWordsSQL = "DELETE FROM Words WHERE dictionaryName = ?"
                try db.execute(sql: deleteWordsSQL, arguments: [dictionary.tableName])
            },
            successHandler: { _ in
                print("[DictionaryActionViewModel]: Словарь успешно удалён")
                completion(.success(()))
            },
            errorHandler: { error in
                self.handleError(
                    error: error,
                    source: .dictionaryDelete,
                    message: "Не удалось удалить словарь из базы данных",
                    tab: .dictionaries
                )
                completion(.failure(error))
            }
        )
    }

    // Получение списка словарей из базы данных
    func getDictionaries(completion: @escaping (Result<[DictionaryItem], Error>) -> Void) {
        performDatabaseOperation(
            { db in
                return try DictionaryItem.fetchAll(db)
            },
            successHandler: { fetchedDictionaries in
                print("[DictionaryActionViewModel]: Словари успешно получены")
                completion(.success(fetchedDictionaries))
            },
            errorHandler: { error in
                self.handleError(
                    error: error,
                    source: .dictionariesGet,
                    message: "Не удалось получить словари из базы данных",
                    tab: .dictionaries
                )
                completion(.failure(error))
            }
        )
    }

    // Обновление статуса активности словаря
    func updateDictionaryStatus(dictionaryID: Int, newStatus: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        performDatabaseOperation(
            { db in
                try DictionaryItem.updateStatus(in: db, dictionaryID: dictionaryID, newStatus: newStatus)
            },
            successHandler: { _ in
                print("[DictionaryActionViewModel]: Статус словаря успешно обновлен")
                completion(.success(()))
            },
            errorHandler: { error in
                self.handleError(
                    error: error,
                    source: .dictionaryUpdate,
                    message: "Не удалось обновить статус словаря в базе данных",
                    tab: .dictionaries
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
        print("[DictionaryActionViewModel]: \(message): \(error)")
        let appError = AppError(
            errorType: .database,
            errorMessage: message,
            additionalInfo: ["error": "\(error)"]
        )
        ErrorManager.shared.setError(appError: appError, tab: tab, source: source)
    }
}
