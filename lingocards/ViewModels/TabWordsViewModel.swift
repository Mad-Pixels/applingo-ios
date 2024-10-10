import Foundation
import Combine

final class TabWordsViewModel: ObservableObject {
    @Published var words: [WordItem] = []
    @Published var searchText: String = "" {
        didSet {
            // Вызов getWords только при изменении searchText и активной вкладке
            if isActiveTab {
                Logger.debug("BBBBB: getwords")
                getWords(search: searchText)
            }
        }
    }
    
    private var cancellable: AnyCancellable?
    private var errorCancellable: AnyCancellable?
    private var isActiveTab: Bool = false  // Флаг активности вкладки

    init() {
        // Подписка на уведомление при выборе вкладки Words
        cancellable = NotificationCenter.default
            .publisher(for: .didSelectWordsTab)
            .sink { [weak self] _ in
                self?.isActiveTab = true  // Устанавливаем флаг активности
                Logger.debug("AAA: flag isActiveTab true")
                self?.getWords(search: self?.searchText ?? "")
            }

        // Подписка на изменения видимости ошибки
//        errorCancellable = ErrorManager.shared.$isErrorVisible
//            .sink { [weak self] isVisible in
//                // Если ошибка исчезла и вкладка активна, вызываем getWords
//                if !isVisible, self?.isActiveTab == true {
//                    self?.getWords(search: self?.searchText ?? "")
//                }
//            }
    }

    // Основной метод получения данных
    func getWords(search: String = "") {
        // Проверяем, существует ли активная ошибка для `getWords`
//        if let error = ErrorManager.shared.currentError, error.source == .getWords {
//            Logger.debug("[WordsViewModel]: Cannot fetch words - an active error from getWords exists.")
//            return
//        }

        Logger.debug("[WordsViewModel]: fetching words...")

        // С вероятностью 10% возвращаем ошибку для `getWords`
        if Int.random(in: 1...10) <= 2 {
            Logger.debug("[WordsViewModel]: failed to fetch words")
            self.words = []

            let error = AppError(
                errorType: .database,
                errorMessage: "Failed to fetch data from database",
                additionalInfo: nil
            )

            // Создаем AppError и передаем в ErrorManager
            ErrorManager.shared.setError(
                appError: error,
                tab: .words,
                source: .getWords
            )
            return
        }

        // Тестовые данные для отображения
        let testData: [WordItem] = [
            WordItem(id: 1, hashId: 1, tableName: "table1", frontText: "Hello", backText: "Привет", description: "", hint: "", createdAt: 1633065600, salt: 1234, success: 14, fail: 5, weight: 6),
            WordItem(id: 2, hashId: 2, tableName: "table1", frontText: "Apple", backText: "Яблоко", description: "Fruit", hint: "A type of fruit", createdAt: 1633065700, salt: 2345),
            WordItem(id: 3, hashId: 3, tableName: "table1", frontText: "Dog", backText: "Собака", description: "Animal", hint: "A common pet", createdAt: 1633065800, salt: 3456),
            WordItem(id: 4, hashId: 4, tableName: "table1", frontText: "Cat", backText: "Кошка", description: "Animal", hint: "A common pet", createdAt: 1633065900, salt: 4567),
            WordItem(id: 5, hashId: 5, tableName: "table1", frontText: "Sun", backText: "Солнце", description: "Celestial Body", hint: "Appears in the sky during the day", createdAt: 1633066000, salt: 5678),
            WordItem(id: 6, hashId: 6, tableName: "table1", frontText: "Water", backText: "Вода", description: "Liquid", hint: "Essential for life", createdAt: 1633066100, salt: 6789),
            WordItem(id: 7, hashId: 7, tableName: "table1", frontText: "Tree", backText: "Дерево", description: "Plant", hint: "Has leaves and branches", createdAt: 1633066200, salt: 7890),
            WordItem(id: 8, hashId: 8, tableName: "table1", frontText: "House", backText: "Дом", description: "Building", hint: "Where people live", createdAt: 1633066300, salt: 8901),
            WordItem(id: 9, hashId: 9, tableName: "table1", frontText: "Car", backText: "Машина", description: "Vehicle", hint: "Used for transportation", createdAt: 1633066400, salt: 9012),
            WordItem(id: 10, hashId: 10, tableName: "table1", frontText: "Book", backText: "Книга", description: "Object", hint: "Used for reading", createdAt: 1633066500, salt: 10123)
        ]

        if search.isEmpty {
            words = testData
        } else {
            words = testData.filter { $0.frontText.localizedCaseInsensitiveContains(search) || $0.backText.localizedCaseInsensitiveContains(search) }
        }

        // Ошибок нет — очищаем ошибку для `getWords`
        ErrorManager.shared.clearError(for: .getWords)
        Logger.debug("[WordsViewModel]: Words data successfully fetched")
    }

    deinit {
        cancellable?.cancel()
        errorCancellable?.cancel()
    }

    func updateWord(_ updatedWord: WordItem) {
        // С вероятностью 10% возвращаем ошибку
        if Int.random(in: 1...3) <= 1 {
            let e = AppError(
                errorType: .database,
                errorMessage: "Failed to update word with ID \(updatedWord.id) due to database issues",
                additionalInfo: nil
            )
            
            ErrorManager.shared.setError(appError: e, tab: .words, source: .updateWord)
            return
        }

        // Логика обновления слова в массиве
        if let index = words.firstIndex(where: { $0.id == updatedWord.id }) {
            words[index] = updatedWord
        }
        Logger.debug("[WordsViewModel]: Word updated successfully")
    }

    func deleteWord(_ word: WordItem) {
        // С вероятностью 10% возвращаем ошибку
        if Int.random(in: 1...3) <= 1 {
            let error = AppError(
                errorType: .database,
                errorMessage: "Failed to delete the word due to database issues",
                additionalInfo: ["Context": "TabWordsViewModel", "WordID": "\(word.id)"]
            )
            ErrorManager.shared.setError(appError: error, tab: .words, source: .deleteWord)
            Logger.debug("[WordsViewModel]: Failed to delete word with ID \(word.id) due to database issues")
            return
        }

        // Логика удаления из массива
        words.removeAll { $0.id == word.id }
        Logger.debug("[WordsViewModel]: Word was deleted successfully")
    }
    
    func saveWord(_ word: WordItem) {
        if Int.random(in: 1...10) <= 0 {
            Logger.debug("[WordsViewModel]: Failed to save word")

            let error = AppError(
                errorType: .database,
                errorMessage: "Failed to save word due to database issues",
                additionalInfo: ["WordID": "\(word.id)"]
            )

            ErrorManager.shared.setError(appError: error, tab: .words, source: .saveWord)
            return
        }

        words.append(word)
        Logger.debug("[WordsViewModel]: Word saved successfully")
    }
    
    func getDictionaries() -> [DictionaryItem] {
        if Int.random(in: 1...10) <= 0 {
            Logger.debug("[WordsViewModel]: Failed to fetch dictionaries")
                
            let error = AppError(
                errorType: .database,
                errorMessage: "Failed to fetch dictionaries due to database issues",
                additionalInfo: nil
            )
                
            ErrorManager.shared.setError(appError: error, tab: .dictionaries, source: .fetchData)
            return []
        }

        let dictionaries: [DictionaryItem] = [
            DictionaryItem(id: 1, hashId: 101, displayName: "English Words", tableName: "english_words", description: "Basic English vocabulary", category: "Language", subcategory: "en-ru", author: "Author1", createdAt: 1633065600, isPrivate: false, isActive: true),
            DictionaryItem(id: 2, hashId: 102, displayName: "French Words", tableName: "french_words", description: "Basic French vocabulary", category: "Language", subcategory: "fr-ru", author: "Author2", createdAt: 1633065700, isPrivate: false, isActive: true),
            DictionaryItem(id: 3, hashId: 103, displayName: "Spanish Words", tableName: "spanish_words", description: "Basic Spanish vocabulary", category: "Language", subcategory: "es-ru", author: "Author3", createdAt: 1633065800, isPrivate: false, isActive: true),
            DictionaryItem(id: 4, hashId: 104, displayName: "German Words", tableName: "german_words", description: "Basic German vocabulary", category: "Language", subcategory: "d-ru", author: "Author4", createdAt: 1633065900, isPrivate: false, isActive: true),
            DictionaryItem(id: 5, hashId: 105, displayName: "Russian Words", tableName: "russian_words", description: "Basic Russian vocabulary", category: "Language", subcategory: "ru-ru", author: "Author5", createdAt: 1633066000, isPrivate: false, isActive: true)
        ]

        Logger.debug("[WordsViewModel]: Dictionaries data successfully fetched")
        return dictionaries
    }
}
