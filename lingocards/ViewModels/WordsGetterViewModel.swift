import Foundation
import Combine
import GRDB

final class WordsGetterViewModel: ObservableObject {
    @Published var words: [WordItem] = []
    @Published var searchText: String = ""
    
    private let windowSize: Int = 50
    private let itemsPerPage: Int = 20
    private var totalFetchedWords: [WordItem] = []
    private var hasMorePagesUp = true
    private var hasMorePagesDown = true
    var isLoadingPage = false
    
    enum LoadDirection {
        case up
        case down
    }
    
    // Сброс пагинации
    func resetPagination() {
        hasMorePagesDown = true
        hasMorePagesUp = true
        words.removeAll()
        totalFetchedWords.removeAll()
        print("🔄 Reset - Up: \(hasMorePagesUp), Down: \(hasMorePagesDown)")
    }
    
    // Получение слов из базы данных
    func get(direction: LoadDirection = .down) {
        guard !isLoadingPage else {
            print("⚠️ Уже идёт загрузка страницы, запрос игнорируется.")
            return
        }
        
        isLoadingPage = true
        print("🔄 Начинаем загрузку слов с направлением: \(direction)")
        
        performDatabaseOperation(
            { db in
                let activeDictionaries = try DictionaryItem.fetchActiveDictionaries(in: db)
                guard let selectedDictionary = activeDictionaries.first else {
                    print("⚠️ Не найден активный словарь.")
                    return [WordItem]()
                }
                
                var query = """
                    SELECT *, '\(selectedDictionary.tableName)' AS tableName 
                    FROM \(selectedDictionary.tableName)
                """
                
                if !self.searchText.isEmpty {
                    let search = self.searchText.lowercased()
                    query += " WHERE LOWER(word) LIKE '%\(search)%'"
                }
                
                if direction == .down {
                    if let lastWord = self.totalFetchedWords.last {
                        let lastId = lastWord.id
                        query += self.searchText.isEmpty ? " WHERE " : " AND "
                        query += "id < \(lastId)"
                    }
                    query += " ORDER BY id DESC LIMIT \(self.itemsPerPage)"
                } else if direction == .up {
                    // Всегда устанавливаем hasMorePagesUp в true
                    self.hasMorePagesUp = true
                    if let firstWord = self.totalFetchedWords.first {
                        let firstId = firstWord.id
                        query += self.searchText.isEmpty ? " WHERE " : " AND "
                        query += "id > \(firstId)"
                    }
                    query += " ORDER BY id ASC LIMIT \(self.itemsPerPage)"
                }
                
                print("🔍 SQL Запрос: \(query)")
                let fetched = try SQLRequest<WordItem>(sql: query).fetchAll(db)
                print("📊 Получено \(fetched.count) элементов из БД.")
                return fetched
            },
            successHandler: { [weak self] fetchedWords in
                guard let self = self else { return }
                
                if direction == .down {
                    if fetchedWords.isEmpty {
                        self.hasMorePagesDown = false
                        print("⚠️ Больше нет страниц вниз.")
                    } else {
                        self.updateVisibleWindow(fetchedWords: fetchedWords, direction: direction)
                    }
                } else if direction == .up {
                    if fetchedWords.isEmpty {
                        self.hasMorePagesUp = true  // Всегда оставляем true
                        print("⚠️ Больше нет страниц вверх, но hasMorePagesUp остаётся true.")
                    } else {
                        self.updateVisibleWindow(fetchedWords: fetchedWords, direction: direction)
                    }
                }
                
                self.isLoadingPage = false
            },
            errorHandler: { error in
                print("❌ Ошибка при загрузке слов: \(error)")
                self.isLoadingPage = false
            }
        )
    }
    
    // Обновление видимого окна слов
    func updateVisibleWindow(fetchedWords: [WordItem], direction: LoadDirection) {
        if direction == .down {
            totalFetchedWords.append(contentsOf: fetchedWords)
            hasMorePagesDown = fetchedWords.count == itemsPerPage
            if totalFetchedWords.count > windowSize {
                totalFetchedWords.removeFirst(fetchedWords.count)
            }
            let newEnd = totalFetchedWords.count
            let newStart = max(newEnd - windowSize, 0)
            words = Array(totalFetchedWords[newStart..<newEnd])
        } else if direction == .up {
            totalFetchedWords.insert(contentsOf: fetchedWords, at: 0)
            hasMorePagesUp = fetchedWords.count == itemsPerPage
            if totalFetchedWords.count > windowSize {
                totalFetchedWords.removeLast(fetchedWords.count)
            }
            let newStart = 0
            let newEnd = min(windowSize, totalFetchedWords.count)
            words = Array(totalFetchedWords[newStart..<newEnd])
        }
        
        print("🎯 Обновлено окно: \(words.count) слов")
        isLoadingPage = false
    }
    
    // Загрузка дополнительных слов при необходимости
    func loadMoreWordsIfNeeded(currentItem word: WordItem?) {
        guard let word = word,
              let currentIndex = words.firstIndex(where: { $0.id == word.id }) else {
            return
        }
        
        print("👁️ Проверка - индекс: \(currentIndex), id: \(word.id), isLoadingPage: \(isLoadingPage), hasMorePagesUp: \(hasMorePagesUp), hasMorePagesDown: \(hasMorePagesDown)")
        
        if currentIndex <= 5 && hasMorePagesUp && !isLoadingPage {
            print("⬆️ Попытка загрузки ВВЕРХ")
            get(direction: .up)
        } else if currentIndex >= words.count - 5 && hasMorePagesDown && !isLoadingPage {
            print("⬇️ Попытка загрузки ВНИЗ")
            get(direction: .down)
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
}
