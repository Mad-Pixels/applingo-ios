import Foundation
import Combine

final class TabDictionariesViewModel: ObservableObject {
    @Published var dictionaries: [DictionaryItem] = []  // Список словарей
    private var cancellable: AnyCancellable?
    private var isActiveTab: Bool = false  // Флаг активности вкладки

    init() {
        // Подписка на уведомление при выборе вкладки Dictionaries
        cancellable = NotificationCenter.default
            .publisher(for: .didSelectDictionariesTab)
            .sink { [weak self] _ in
                self?.isActiveTab = true  // Устанавливаем флаг активности
                Logger.debug("[TabDictionariesViewModel]: Dictionaries tab selected")
                self?.getDictionaries()  // Загружаем словари при активации вкладки
            }
    }

    deinit {
        cancellable?.cancel()
    }
    
    func getRemoteDictionaries(query: DictionaryQueryRequest) {
        Logger.debug("[TabDictionariesViewModel]: Fetching remote dictionaries with query parameters: \(query)")

        // Симуляция сетевого запроса с вероятностью ошибки 10%
        if Int.random(in: 1...10) <= 1 {
            Logger.debug("[TabDictionariesViewModel]: Failed to fetch remote dictionaries")

            self.dictionaries = []

            let error = AppError(
                errorType: .network,
                errorMessage: "Failed to fetch data from remote server",
                additionalInfo: nil
            )

            // Устанавливаем ошибку в ErrorManager
            ErrorManager.shared.setError(
                appError: error,
                tab: .dictionaries,
                source: .getRemoteDictionaries
            )
            return
        }

        // Пример данных, которые будут получены
        let remoteData: [DictionaryItem] = [
            DictionaryItem(id: 6, hashId: 106, displayName: "Italian Words", tableName: "italian_words", description: "Basic Italian vocabulary", category: "Language", subcategory: "it-en", author: "Author6", createdAt: 1633066100, isPrivate: false, isActive: false),
            DictionaryItem(id: 7, hashId: 107, displayName: "Japanese Words", tableName: "japanese_words", description: "Basic Japanese vocabulary", category: "Language", subcategory: "ja-en", author: "Author7", createdAt: 1633066200, isPrivate: false, isActive: false)
        ]

        // Обновляем словари
        self.dictionaries = remoteData

        // Очищаем ошибки при успешном выполнении запроса
        ErrorManager.shared.clearError(for: .getRemoteDictionaries)
        Logger.debug("[TabDictionariesViewModel]: Remote dictionaries data successfully fetched")
    }


    // Основной метод получения данных словарей
    func getDictionaries() {
        Logger.debug("[TabDictionariesViewModel]: Fetching dictionaries from database...")

        guard DatabaseManager.shared.isConnected else {
            let error = AppError(
                errorType: .database,
                errorMessage: "Database is not connected",
                additionalInfo: nil
            )
            ErrorManager.shared.setError(
                appError: error,
                tab: .dictionaries,
                source: .getDictionaries
            )
            return
        }

        do {
            try DatabaseManager.shared.databaseQueue?.read { db in
                let fetchedDictionaries = try DictionaryItem.fetchAll(db)  // Получаем все данные из таблицы
                DispatchQueue.main.async {
                    self.dictionaries = fetchedDictionaries
                    Logger.debug("[TabDictionariesViewModel]: Dictionaries data successfully fetched from database")
                }
            }

            ErrorManager.shared.clearError(for: .getDictionaries)
        } catch {
            Logger.debug("[TabDictionariesViewModel]: Failed to fetch dictionaries from database: \(error)")
            let appError = AppError(
                errorType: .database,
                errorMessage: "Failed to fetch data from database",
                additionalInfo: ["error": "\(error)"]
            )
            ErrorManager.shared.setError(
                appError: appError,
                tab: .dictionaries,
                source: .getDictionaries
            )
        }
    }

    func deleteDictionary(_ dictionary: DictionaryItem) {
        Logger.debug("[TabDictionariesViewModel]: Deleting dictionary with ID \(dictionary.id)")

        guard DatabaseManager.shared.isConnected else {
            let error = AppError(
                errorType: .database,
                errorMessage: "Database is not connected",
                additionalInfo: nil
            )
            ErrorManager.shared.setError(appError: error, tab: .dictionaries, source: .deleteDictionary)
            return
        }

        do {
            // Удаляем словарь из базы данных
            try DatabaseManager.shared.databaseQueue?.write { db in
                // Удаляем запись в таблице Dictionary
                try db.execute(
                    sql: "DELETE FROM \(DictionaryItem.databaseTableName) WHERE id = ?",
                    arguments: [dictionary.id]
                )
                
                // Удаляем таблицу слов, связанную с данным словарём
                try db.execute(
                    sql: "DROP TABLE IF EXISTS \(dictionary.tableName)"
                )
            }

            // Удаляем словарь из локального массива
            if let index = dictionaries.firstIndex(where: { $0.id == dictionary.id }) {
                dictionaries.remove(at: index)
                Logger.debug("[TabDictionariesViewModel]: Dictionary with ID \(dictionary.id) was deleted successfully, along with its table \(dictionary.tableName)")
            }

            ErrorManager.shared.clearError(for: .deleteDictionary)
        } catch {
            Logger.debug("[TabDictionariesViewModel]: Failed to delete dictionary from database: \(error)")
            let appError = AppError(
                errorType: .database,
                errorMessage: "Failed to delete dictionary from database",
                additionalInfo: ["error": "\(error)"]
            )
            ErrorManager.shared.setError(appError: appError, tab: .dictionaries, source: .deleteDictionary)
        }
    }
    
    func updateDictionary(_ updatedDictionary: DictionaryItem, completion: @escaping (Result<Void, Error>) -> Void) {
            // С вероятностью 10% возвращаем ошибку
            if Int.random(in: 1...3) <= 1 {
                let error = AppError(
                    errorType: .database,
                    errorMessage: "Failed to update dictionary with ID \(updatedDictionary.id) due to database issues",
                    additionalInfo: nil
                )
                completion(.failure(error))
                return
            }

            // Ищем индекс словаря, который нужно обновить
            if let index = dictionaries.firstIndex(where: { $0.id == updatedDictionary.id }) {
                dictionaries[index] = updatedDictionary
                Logger.debug("[TabDictionariesViewModel]: Dictionary updated successfully")
                completion(.success(()))
            } else {
                // Обрабатываем случай, когда словарь не найден
                let error = AppError(
                    errorType: .unknown,
                    errorMessage: "Dictionary with ID \(updatedDictionary.id) not found",
                    additionalInfo: nil
                )
                ErrorManager.shared.setError(appError: error, tab: .dictionaries, source: .updateDictionary)
                completion(.failure(error))
            }
        }
    
    func updateDictionaryStatus(_ dictionaryID: Int, newStatus: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        // С вероятностью 10% возвращаем ошибку
        if Int.random(in: 1...10) <= 1 {
            let error = AppError(
                errorType: .database,
                errorMessage: "Failed to update dictionary status with ID \(dictionaryID) due to database issues",
                additionalInfo: nil
            )
            completion(.failure(error))
            return
        }

        // Ищем индекс словаря, который нужно обновить
        if let index = dictionaries.firstIndex(where: { $0.id == dictionaryID }) {
            // Обновляем только статус словаря
            dictionaries[index].isActive = newStatus
            Logger.debug("[TabDictionariesViewModel]: Dictionary status updated successfully")
            completion(.success(()))
        } else {
            // Обрабатываем случай, когда словарь не найден
            let error = AppError(
                errorType: .unknown,
                errorMessage: "Dictionary with ID \(dictionaryID) not found",
                additionalInfo: nil
            )
            ErrorManager.shared.setError(appError: error, tab: .dictionaries, source: .updateDictionary)
            completion(.failure(error))
        }
    }
}
