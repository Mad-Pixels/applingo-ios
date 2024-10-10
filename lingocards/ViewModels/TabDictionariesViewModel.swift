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

    // Основной метод получения данных словарей
    func getDictionaries() {
        Logger.debug("[TabDictionariesViewModel]: Fetching dictionaries...")

        // С вероятностью 10% возвращаем ошибку для `getDictionaries`
        if Int.random(in: 1...10) <= 1 {
            Logger.debug("[TabDictionariesViewModel]: Failed to fetch dictionaries")

            self.dictionaries = []  // Очищаем текущие данные

            let error = AppError(
                errorType: .database,
                errorMessage: "Failed to fetch data from database",
                additionalInfo: nil
            )

            // Создаем AppError и передаем в ErrorManager
            ErrorManager.shared.setError(
                appError: error,
                tab: .dictionaries,
                source: .getDictionaries
            )
            return
        }

        // Тестовые данные для отображения
        let testData: [DictionaryItem] = [
            DictionaryItem(id: 1, hashId: 101, displayName: "English Words", tableName: "english_words", description: "Basic English vocabulary", category: "Language", subcategory: "en-en", author: "Author1", createdAt: 1633065600, isPrivate: false, isActive: true),
            DictionaryItem(id: 2, hashId: 102, displayName: "French Words", tableName: "french_words", description: "Basic French vocabulary", category: "Language", subcategory: "en-en", author: "Author2", createdAt: 1633065700, isPrivate: false, isActive: true),
            DictionaryItem(id: 3, hashId: 103, displayName: "Spanish Words", tableName: "spanish_words", description: "Basic Spanish vocabulary", category: "Language", subcategory: "en-en", author: "Author3", createdAt: 1633065800, isPrivate: false, isActive: true),
            DictionaryItem(id: 4, hashId: 104, displayName: "German Words", tableName: "german_words", description: "Basic German vocabulary", category: "Language", subcategory: "en-en", author: "Author4", createdAt: 1633065900, isPrivate: false, isActive: true),
            DictionaryItem(id: 5, hashId: 105, displayName: "Russian Words", tableName: "russian_words", description: "Basic Russian vocabulary", category: "Language", subcategory: "en-en", author: "Author5", createdAt: 1633066000, isPrivate: false, isActive: true)
        ]

        // Обновляем Published переменную
        self.dictionaries = testData

        // Ошибок нет — очищаем ошибку для `getDictionaries`
        ErrorManager.shared.clearError(for: .getDictionaries)
        Logger.debug("[TabDictionariesViewModel]: Dictionaries data successfully fetched")
    }
    
    func deleteDictionary(_ dictionary: DictionaryItem) {
        // С вероятностью 10% возвращаем ошибку
        if Int.random(in: 1...3) <= 1 {
            let error = AppError(
                errorType: .database,
                errorMessage: "Failed to delete the dictionary due to database issues",
                additionalInfo: ["Context": "TabDictionariesViewModel", "DictionaryID": "\(dictionary.id)"]
            )
            ErrorManager.shared.setError(appError: error, tab: .dictionaries, source: .deleteDictionary)
            Logger.debug("[DictionariesViewModel]: Failed to delete dictionary with ID \(dictionary.id) due to database issues")
            return
        }

        // Логика удаления из массива
        dictionaries.removeAll { $0.id == dictionary.id }
        Logger.debug("[DictionariesViewModel]: Dictionary was deleted successfully")
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
}
