import GRDB

class RepositoryWord: WordRepositoryProtocol {
    private let dbQueue: DatabaseQueue
    
    init(dbQueue: DatabaseQueue) {
        self.dbQueue = dbQueue
    }
    
    func fetch(
        searchText: String?,
        offset: Int,
        limit: Int
    ) throws -> [WordItem] {
        let activeDictionaries = try fetchActive()
        let activeDisplayNames = activeDictionaries.map { $0.tableName } as [DatabaseValueConvertible]
        
        return try dbQueue.read { db -> [WordItem] in
            var sql: String
            var allArguments: [DatabaseValueConvertible] = []
            
            var conditions: [String] = []
            
            // Добавляем условия фильтрации по активным словарям
            if !activeDisplayNames.isEmpty {
                let placeholders = activeDisplayNames.map { _ in "?" }.joined(separator: ", ")
                conditions.append("tableName IN (\(placeholders))")
                allArguments.append(contentsOf: activeDisplayNames)
            }
            
            // Добавляем условие поиска по тексту
            if let searchText = searchText, !searchText.isEmpty {
                // Если есть поисковый текст, добавляем условия для релевантности
                sql = "SELECT *, CASE" +
                    " WHEN LOWER(frontText) = LOWER(?) THEN 1" +
                    " WHEN LOWER(frontText) LIKE LOWER(? || '%') THEN 2" +
                    " WHEN LOWER(frontText) LIKE LOWER('%' || ? || '%') THEN 3" +
                    " ELSE 4 END AS relevance" +
                    " FROM \(WordItem.databaseTableName)"
                
                var relevanceArguments: [DatabaseValueConvertible] = []
                relevanceArguments.append(searchText)
                relevanceArguments.append(searchText)
                relevanceArguments.append(searchText)
                
                // Добавляем условие поиска по тексту
                conditions.append("LOWER(frontText) LIKE ?")
                allArguments.append("%\(searchText.lowercased())%")
                
                allArguments = relevanceArguments + allArguments  // Собираем все аргументы
            } else {
                // Если поискового текста нет, не добавляем CASE и условия поиска
                sql = "SELECT * FROM \(WordItem.databaseTableName)"
            }
            
            // Добавляем условия в запрос
            if !conditions.isEmpty {
                sql += " WHERE " + conditions.joined(separator: " AND ")
            }
            
            // Добавляем сортировку
            if let searchText = searchText, !searchText.isEmpty {
                sql += " ORDER BY relevance ASC, id ASC"
            } else {
                sql += " ORDER BY id ASC"
            }
            
            // Добавляем ограничения по лимиту и смещению
            sql += " LIMIT ? OFFSET ?"
            allArguments.append(limit)
            allArguments.append(offset)
            
            Logger.debug("[RepositoryWord]: fetch with SQL \(sql) and arguments \(allArguments)")
            
            let request = SQLRequest<WordItem>(
                sql: sql,
                arguments: StatementArguments(allArguments)
            )
            return try request.fetchAll(db)
        }
    }


    
    func save(_ word: WordItem) throws {
        try dbQueue.write { db in
            try word.insert(db)
        }
        Logger.debug("[RepositoryWord]: save - \(word)")
    }
    
    func update(_ word: WordItem) throws {
        try dbQueue.write { db in
            try word.update(db)
        }
        Logger.debug("[RepositoryWord]: update - \(word)")
    }
    
    func delete(_ word: WordItem) throws {
        _ = try dbQueue.write { db in
            try word.delete(db)
        }
        Logger.debug("[RepositoryWord]: delete - \(word)")
    }
    
    private func fetchActive() throws -> [DictionaryItem] {
        return try dbQueue.read { db in
            let sql = "SELECT * FROM \(DictionaryItem.databaseTableName) WHERE isActive = 1"
            Logger.debug("[RepositoryWord]: fetchActive - \(sql)")
            return try DictionaryItem.fetchAll(db, sql: sql)
        }
    }
}
