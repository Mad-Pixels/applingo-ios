import GRDB

class RepositoryWord: WordRepositoryProtocol {
    private let dbQueue: DatabaseQueue
    
    init(dbQueue: DatabaseQueue) {
        self.dbQueue = dbQueue
    }
    
    func fetch(
        searchText: String?,
        lastItem: WordItem?,
        limit: Int
    ) throws -> [WordItem] {
        let activeDictionaries = try fetchActive()
        let activeDisplayNames = activeDictionaries.map { $0.tableName } as [DatabaseValueConvertible]
        
        return try dbQueue.read { db -> [WordItem] in
            var sql = "SELECT * FROM \(WordItem.databaseTableName)"
            
            var conditions: [String] = []
            var allArguments: [DatabaseValueConvertible] = []
            
            if !activeDisplayNames.isEmpty {
                let placeholders = activeDisplayNames.map { _ in "?" }.joined(separator: ", ")
                conditions.append("tableName IN (\(placeholders))")
                allArguments.append(contentsOf: activeDisplayNames)
            }
            if let searchText = searchText, !searchText.isEmpty {
                conditions.append("LOWER(frontText) LIKE ?")
                allArguments.append("%\(searchText.lowercased())%")
            }
            if let lastItem = lastItem {
                conditions.append("id > ?")
                allArguments.append(lastItem.id)
            }
            if !conditions.isEmpty {
                sql += " WHERE " + conditions.joined(separator: " AND ")
            }
            sql += " ORDER BY id ASC LIMIT ?"
            allArguments.append(limit)
            
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
