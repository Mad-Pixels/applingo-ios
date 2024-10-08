import Foundation
import Combine

final class TabWordsViewModel: ObservableObject {
    @Published var words: [WordItem] = []
    @Published var searchText: String = "" {
        didSet {
            // Фильтруем слова при изменении searchText
            getWords(search: searchText)
        }
    }
    
    private var cancellable: AnyCancellable?

    init() {
        // Инициализируем тестовые данные при запуске
        cancellable = NotificationCenter.default
            .publisher(for: .didSelectWordsTab)
            .sink { [weak self] _ in
                // Выполняем загрузку данных, когда вкладка "Words" выбрана
                self?.getWords(search: self?.searchText ?? "")
            }
    }

    // Метод для фильтрации и получения слов
    func getWords(search: String = "") {
        Logger.debug("[WordsViewModel]: fetching words...")

        // Тестовые данные
        let testData: [WordItem] = [
            WordItem(id: 1, hashId: 1, tableName: "table1", frontText: "Hello", backText: "Привет", description: "", hint: "", createdAt: 1633065600, salt: 1234, success: 14, fail: 5, weight: 6),
        WordItem(id: 2, hashId: 2, tableName: "table1", frontText: "Apple", backText: "Яблоко", description: "AAAA BBBBB CCCCC DDDDD EEEEEE FFFFF GGGGG HHHHH IIII JJJJJ KKKKK LLLLL MMMMM NNNNN OOOOO PPPPP QQQQQ RRRRR SSSSS TTTTT UUUUU VVVVV WWWWW XXXXX YYYYY ZZZZZ AAAA BBBBB CCCCC DDDDD EEEEEE FFFFF GGGGG HHHHH IIII JJJJJ UUUUU VVVVV WWWWW XXXXX YYYYY ZZZZZ AAAA BBBBB CCCCC DDDDD EEEEEE ", hint: "A type of fruit", createdAt: 1633065700, salt: 2345),
            WordItem(id: 3, hashId: 3, tableName: "table1", frontText: "Dog", backText: "Собака", description: "Animal", hint: "A common pet", createdAt: 1633065800, salt: 3456),
            WordItem(id: 4, hashId: 4, tableName: "table1", frontText: "Cat", backText: "Кошка", description: "Animal", hint: "A common pet", createdAt: 1633065900, salt: 4567),
            WordItem(id: 5, hashId: 5, tableName: "table1", frontText: "Sun", backText: "Солнце", description: "Celestial Body", hint: "Appears in the sky during the day", createdAt: 1633066000, salt: 5678),
            WordItem(id: 6, hashId: 6, tableName: "table1", frontText: "Water", backText: "Вода", description: "Liquid", hint: "Essential for life", createdAt: 1633066100, salt: 6789),
            WordItem(id: 7, hashId: 7, tableName: "table1", frontText: "Tree", backText: "Дерево", description: "Plant", hint: "Has leaves and branches", createdAt: 1633066200, salt: 7890),
            WordItem(id: 8, hashId: 8, tableName: "table1", frontText: "House", backText: "Дом", description: "Building", hint: "Where people live", createdAt: 1633066300, salt: 8901),
            WordItem(id: 9, hashId: 9, tableName: "table1", frontText: "Car", backText: "Машина", description: "Vehicle", hint: "Used for transportation", createdAt: 1633066400, salt: 9012),
            WordItem(id: 10, hashId: 10, tableName: "table1", frontText: "Book", backText: "Книга", description: "Object", hint: "Used for reading", createdAt: 1633066500, salt: 10123)
        ]

        // Фильтруем данные по запросу поиска
        if search.isEmpty {
            words = testData
        } else {
            words = testData.filter { $0.frontText.localizedCaseInsensitiveContains(search) || $0.backText.localizedCaseInsensitiveContains(search) }
        }

        Logger.debug("[WordsViewModel]: Words data successfully fetched")
    }
    
    deinit {
        cancellable?.cancel()  // Отменяем подписку на уведомление при удалении объекта
    }
    
    func updateWord(_ updatedWord: WordItem) {
            if let index = words.firstIndex(where: { $0.id == updatedWord.id }) {
                words[index] = updatedWord
            }
            Logger.debug("[WordsViewModel]: Word updated successfully")
        }
}
