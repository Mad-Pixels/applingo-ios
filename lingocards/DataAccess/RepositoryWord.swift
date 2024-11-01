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
            
            if !activeDisplayNames.isEmpty {
                let placeholders = activeDisplayNames.map { _ in "?" }.joined(separator: ", ")
                conditions.append("tableName IN (\(placeholders))")
                allArguments.append(contentsOf: activeDisplayNames)
            }
            
            let trimmedSearchText = searchText?.trimmingCharacters(in: .whitespacesAndNewlines)
            let hasSearchText = !(trimmedSearchText?.isEmpty ?? true)
            
            if hasSearchText, let searchText = trimmedSearchText {
                sql = """
                SELECT *, CASE
                    WHEN LOWER(frontText) = LOWER(?) THEN 1
                    WHEN LOWER(frontText) LIKE LOWER(? || '%') THEN 2
                    WHEN LOWER(frontText) LIKE LOWER('%' || ? || '%') THEN 3
                    ELSE 4 END AS relevance
                FROM \(WordItem.databaseTableName)
                """
                
                let relevanceArguments: [DatabaseValueConvertible] = [searchText, searchText, searchText]
                allArguments = relevanceArguments + allArguments  // Combine arguments
                
                conditions.append("LOWER(frontText) LIKE ?")
                allArguments.append("%\(searchText.lowercased())%")
            } else {
                sql = "SELECT * FROM \(WordItem.databaseTableName)"
            }
            if !conditions.isEmpty {
                sql += " WHERE " + conditions.joined(separator: " AND ")
            }
            if hasSearchText {
                sql += " ORDER BY relevance ASC, id ASC"
            } else {
                sql += " ORDER BY id ASC"
            }
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
        var fmtWord = word
        fmtWord.fmt()
        
        try dbQueue.write { db in
            try fmtWord.insert(db)
        }
        Logger.debug("[RepositoryWord]: save - \(word)")
    }
    
    func update(_ word: WordItem) throws {
        var fmtWord = word
        fmtWord.fmt()
        
        try dbQueue.write { db in
            try fmtWord.update(db)
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
