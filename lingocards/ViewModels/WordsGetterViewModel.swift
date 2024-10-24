import SwiftUI
import Combine
import GRDB

final class WordsGetterViewModel: ObservableObject {
    @Published var words: [WordItem] = []
    @Published var searchText: String = ""
    
    private let windowSize: Int = 1000  // Увеличим размер окна, чтобы избежать частого удаления элементов
    private let itemsPerPage: Int = 50  // Увеличим размер страницы для более эффективной загрузки
    
    private var isLoadingPage = false
    private var hasMorePagesUp = true
    private var hasMorePagesDown = true
    
    enum LoadDirection {
        case up
        case down
    }
    
    // Сброс пагинации
    func resetPagination() {
        words.removeAll()
        isLoadingPage = false
        hasMorePagesUp = true
        hasMorePagesDown = true
        get(direction: .down)  // Начинаем загрузку с последней страницы
    }
    
    // Получение слов из базы данных
    func get(direction: LoadDirection = .down) {
        guard !isLoadingPage else { return }
        isLoadingPage = true
        
        performDatabaseOperation(
            { db -> [WordItem] in
                let activeDictionaries = try DictionaryItem.fetchActiveDictionaries(in: db)
                guard let selectedDictionary = activeDictionaries.first else {
                    print("⚠️ Не найден активный словарь.")
                    return []
                }
                
                let tableName = selectedDictionary.tableName
                var query = """
                    SELECT *, '\(tableName)' AS tableName 
                    FROM \(tableName)
                """
                
                var whereClauses: [String] = []
                if !self.searchText.isEmpty {
                    let search = self.searchText.lowercased()
                    whereClauses.append("LOWER(word) LIKE '%\(search)%'")
                }
                
                switch direction {
                case .down:
                    if let lastWord = self.words.last {
                        whereClauses.append("id < \(lastWord.id)")
                    }
                    query += whereClauses.isEmpty ? "" : " WHERE " + whereClauses.joined(separator: " AND ")
                    query += " ORDER BY id DESC LIMIT \(self.itemsPerPage)"
                    
                case .up:
                    if let firstWord = self.words.first {
                        whereClauses.append("id > \(firstWord.id)")
                    }
                    query += whereClauses.isEmpty ? "" : " WHERE " + whereClauses.joined(separator: " AND ")
                    query += " ORDER BY id ASC LIMIT \(self.itemsPerPage)"
                }
                
                print("📝 Выполняется запрос: \(query)")
                let fetchedWords = try WordItem.fetchAll(db, sql: query)
                print("📊 Получено \(fetchedWords.count) слов из базы данных.")
                return fetchedWords
            },
            successHandler: { [weak self] fetchedWords in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    self.updateWords(with: fetchedWords, direction: direction)
                    self.isLoadingPage = false
                }
            },
            errorHandler: { [weak self] error in
                print("❌ Ошибка при загрузке слов: \(error)")
                DispatchQueue.main.async {
                    self?.isLoadingPage = false
                }
            }
        )
    }
    
    // Обновление массива `words` с новыми данными
    private func updateWords(with fetchedWords: [WordItem], direction: LoadDirection) {
        if fetchedWords.isEmpty {
            switch direction {
            case .down:
                hasMorePagesDown = false
            case .up:
                hasMorePagesUp = false
            }
            print("⚠️ Больше нет данных для загрузки в направлении \(direction).")
            return
        }
        
        switch direction {
        case .down:
            // Проверяем на дублирование ID
            let newWords = fetchedWords.filter { newWord in
                !self.words.contains(where: { $0.id == newWord.id })
            }
            // Добавляем новые слова в конец списка
            withAnimation {
                self.words.append(contentsOf: newWords)
            }
            
        case .up:
            // Проверяем на дублирование ID
            let newWords = fetchedWords.filter { newWord in
                !self.words.contains(where: { $0.id == newWord.id })
            }
            // Добавляем новые слова в начало списка
            withAnimation {
                self.words.insert(contentsOf: newWords, at: 0)
            }
        }
        
        // Ограничиваем размер массива `words`
        if words.count > windowSize {
            let removeCount = words.count - windowSize
            if direction == .down {
                // Удаляем элементы из начала массива
                words.removeFirst(removeCount)
                print("🗑 Удалено \(removeCount) слов из начала массива.")
            } else {
                // Удаляем элементы из конца массива
                words.removeLast(removeCount)
                print("🗑 Удалено \(removeCount) слов из конца массива.")
            }
        }
        
        print("✅ Массив words обновлен. Текущее количество слов: \(words.count)")
    }
    
    // Загрузка дополнительных слов при необходимости
    func loadMoreWordsIfNeeded(currentItem word: WordItem?) {
        guard let word = word else { return }
        
        if let index = words.firstIndex(where: { $0.id == word.id }) {
            if index <= 5 && hasMorePagesUp && !isLoadingPage {
                // Загрузить больше данных вверх
                get(direction: .up)
            } else if index >= words.count - 5 && hasMorePagesDown && !isLoadingPage {
                // Загрузить больше данных вниз
                get(direction: .down)
            }
        }
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
                if let result = result {
                    successHandler(result)
                }
            } catch {
                errorHandler(error)
            }
        }
    }
}
