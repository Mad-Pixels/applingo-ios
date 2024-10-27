import SwiftUI
import Combine
import GRDB

final class DictionaryLocalGetterViewModel: ObservableObject {
    @Published var dictionaries: [DictionaryItem] = []
    @Published var searchText: String = ""
    
    private let windowSize: Int = 1000
    private let itemsPerPage: Int = 50
    
    private var isLoadingPage = false
    private var hasMorePagesUp = true
    private var hasMorePagesDown = true
    
    enum LoadDirection {
        case up
        case down
    }
    
    // Сброс пагинации
    func resetPagination() {
        dictionaries.removeAll()
        isLoadingPage = false
        hasMorePagesUp = true
        hasMorePagesDown = true
        get(direction: .down)
    }
    
    // Получение словарей из базы данных
    func get(direction: LoadDirection = .down) {
        guard !isLoadingPage else { return }
        isLoadingPage = true
        
        performDatabaseOperation(
            { db -> [DictionaryItem] in
                var query = """
                    SELECT *
                    FROM \(DictionaryItem.databaseTableName)
                """
                
                var whereClauses: [String] = []
                if !self.searchText.isEmpty {
                    let search = self.searchText.lowercased()
                    whereClauses.append("LOWER(displayName) LIKE '%\(search)%'")
                }
                
                switch direction {
                case .down:
                    if let lastDictionary = self.dictionaries.last {
                        whereClauses.append("id < \(lastDictionary.id)")
                    }
                    query += whereClauses.isEmpty ? "" : " WHERE " + whereClauses.joined(separator: " AND ")
                    query += " ORDER BY id DESC LIMIT \(self.itemsPerPage)"
                    
                case .up:
                    if let firstDictionary = self.dictionaries.first {
                        whereClauses.append("id > \(firstDictionary.id)")
                    }
                    query += whereClauses.isEmpty ? "" : " WHERE " + whereClauses.joined(separator: " AND ")
                    query += " ORDER BY id ASC LIMIT \(self.itemsPerPage)"
                }
                
                print("📝 Выполняется запрос: \(query)")
                let fetchedDictionaries = try DictionaryItem.fetchAll(db, sql: query)
                print("📊 Получено \(fetchedDictionaries.count) словарей из базы данных.")
                return fetchedDictionaries
            },
            successHandler: { [weak self] fetchedDictionaries in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    self.updateDictionaries(with: fetchedDictionaries, direction: direction)
                    self.isLoadingPage = false
                }
            },
            errorHandler: { [weak self] error in
                print("❌ Ошибка при загрузке словарей: \(error)")
                DispatchQueue.main.async {
                    self?.isLoadingPage = false
                }
            }
        )
    }
    
    // Обновление массива `dictionaries` с новыми данными
    private func updateDictionaries(with fetchedDictionaries: [DictionaryItem], direction: LoadDirection) {
        if fetchedDictionaries.isEmpty {
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
            let newDictionaries = fetchedDictionaries.filter { newItem in
                !self.dictionaries.contains(where: { $0.id == newItem.id })
            }
            // Добавляем новые словари в конец списка
            withAnimation {
                self.dictionaries.append(contentsOf: newDictionaries)
            }
            
        case .up:
            // Проверяем на дублирование ID
            let newDictionaries = fetchedDictionaries.filter { newItem in
                !self.dictionaries.contains(where: { $0.id == newItem.id })
            }
            // Добавляем новые словари в начало списка
            withAnimation {
                self.dictionaries.insert(contentsOf: newDictionaries, at: 0)
            }
        }
        
        // Ограничиваем размер массива `dictionaries`
        // Закомментировано согласно вашей инструкции
        /*
        if dictionaries.count > windowSize {
            let removeCount = dictionaries.count - windowSize
            if direction == .down {
                // Удаляем элементы из начала массива
                dictionaries.removeFirst(removeCount)
                print("🗑 Удалено \(removeCount) словарей из начала массива.")
            } else {
                // Удаляем элементы из конца массива
                dictionaries.removeLast(removeCount)
                print("🗑 Удалено \(removeCount) словарей из конца массива.")
            }
        }
        */
        
        print("✅ Массив dictionaries обновлен. Текущее количество словарей: \(dictionaries.count)")
    }
    
    // Загрузка дополнительных словарей при необходимости
    func loadMoreDictionariesIfNeeded(currentItem dictionary: DictionaryItem?) {
        guard let dictionary = dictionary else { return }
        
        if let index = dictionaries.firstIndex(where: { $0.id == dictionary.id }) {
            if index <= 5 && hasMorePagesUp && !isLoadingPage {
                // Загрузить больше данных вверх
                get(direction: .up)
            } else if index >= dictionaries.count - 5 && hasMorePagesDown && !isLoadingPage {
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
