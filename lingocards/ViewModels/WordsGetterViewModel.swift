import SwiftUI
import Combine
import GRDB

final class WordsGetterViewModel: ObservableObject {
    @Published var words: [WordItem] = []
    @Published var searchText: String = ""
    
    private var inProgress: Bool = false
    private var last: Bool = false
    private let offset: Int = 50
    
    func resetPagination() {
        words.removeAll()
        inProgress = false
        last = false
        get()
    }
    
    func get() {
        guard !inProgress else { return }
        inProgress = true
        
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
                
                if let lastWord = self.words.last {
                    whereClauses.append("id < \(lastWord.id)")
                }
                
                query += whereClauses.isEmpty ? "" : " WHERE " + whereClauses.joined(separator: " AND ")
                query += " ORDER BY id DESC LIMIT \(self.offset)"
                
                print("📝 Выполняется запрос: \(query)")
                let fetchedWords = try WordItem.fetchAll(db, sql: query)
                print("📊 Получено \(fetchedWords.count) слов из базы данных.")
                return fetchedWords
            },
            successHandler: { [weak self] fetchedWords in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    self.updateWords(with: fetchedWords)
                    self.inProgress = false
                }
            },
            errorHandler: { [weak self] error in
                print("❌ Ошибка при загрузке слов: \(error)")
                DispatchQueue.main.async {
                    self?.inProgress = false
                }
            }
        )
    }
    
    private func updateWords(with fetchedWords: [WordItem]) {
        if fetchedWords.isEmpty {
            last = true
            print("⚠️ Больше нет данных для загрузки.")
            return
        }
        
        let newWords = fetchedWords.filter { newWord in
            !self.words.contains(where: { $0.id == newWord.id })
        }
        
        withAnimation {
            self.words.append(contentsOf: newWords)
        }
        
        print("✅ Массив words обновлен. Текущее количество слов: \(words.count)")
    }
    
    func loadMoreWordsIfNeeded(currentItem word: WordItem?) {
        guard let word = word,
              let index = words.firstIndex(where: { $0.id == word.id }),
              index >= words.count - 5 && !last && !inProgress else { return }
        
        get()
    }
    
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
