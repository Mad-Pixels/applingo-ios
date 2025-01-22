import GRDB

final class WordRepository {
    private let dbQueue: DatabaseQueue
    
    init(dbQueue: DatabaseQueue) {
        self.dbQueue = dbQueue
    }
    
    private func fetchActive() throws -> [DatabaseDictionary] {
        try dbQueue.read { db in
            let sql = "SELECT * FROM \(DatabaseDictionary.databaseTableName) WHERE active = 1"
            return try DatabaseDictionary.fetchAll(db, sql: sql)
        }
    }
    
    func fetch(
        searchText: String?,
        offset: Int,
        limit: Int
    ) throws -> [DatabaseWord] {
        let activeDictionaries = try fetchActive()
        guard !activeDictionaries.isEmpty else {
            return []
        }
        
        let activeDictionaryIds = activeDictionaries.map { $0.id }
        
        return try dbQueue.read { db in
            var sql: String
            var allArguments: [DatabaseValueConvertible] = []
            var conditions: [String] = []
            
            if !activeDictionaryIds.isEmpty {
                let placeholders = activeDictionaryIds.map { String($0) }.joined(separator: ", ")
                conditions.append("dictionaryId IN (\(placeholders))")
            }
            
            let trimmedSearchText = searchText?.trimmingCharacters(in: .whitespacesAndNewlines)
            let hasSearchText = !(trimmedSearchText?.isEmpty ?? true)
            
            if hasSearchText, let searchText = trimmedSearchText {
                sql = """
                SELECT *, CASE
                    WHEN LOWER(frontText) = LOWER(?) OR LOWER(backText) = LOWER(?) THEN 1
                    WHEN LOWER(frontText) LIKE LOWER(? || '%') OR LOWER(backText) LIKE LOWER(? || '%') THEN 2
                    WHEN LOWER(frontText) LIKE LOWER('%' || ? || '%') OR LOWER(backText) LIKE LOWER('%' || ? || '%') THEN 3
                    ELSE 4 END AS relevance
                FROM \(DatabaseWord.databaseTableName)
                """
                
                let relevanceArguments: [DatabaseValueConvertible] = [
                    searchText, searchText,
                    searchText, searchText,
                    searchText, searchText
                ]
                allArguments = relevanceArguments
                
                conditions.append("(LOWER(frontText) LIKE ? OR LOWER(backText) LIKE ?)")
                allArguments.append("%\(searchText.lowercased())%")
                allArguments.append("%\(searchText.lowercased())%")
            } else {
                sql = "SELECT * FROM \(DatabaseWord.databaseTableName)"
            }
            
            if !conditions.isEmpty {
                sql += " WHERE " + conditions.joined(separator: " AND ")
            }
            
            if hasSearchText {
                sql += " ORDER BY relevance ASC, created DESC"
            } else {
                sql += " ORDER BY created DESC"
            }
            
            sql += " LIMIT ? OFFSET ?"
            allArguments.append(limit)
            allArguments.append(offset)
            
            Logger.debug("[WordStorage]: fetch - SQL: \(sql), Arguments: \(allArguments)")
            
            return try DatabaseWord.fetchAll(db, sql: sql, arguments: StatementArguments(allArguments))
        }
    }
    
    func fetchCache(count: Int) throws -> [DatabaseWord] {
        let activeDictionaries = try fetchActive()
        guard !activeDictionaries.isEmpty else {
            return []
        }
        
        let activeDictionaryIds = activeDictionaries.map { $0.id }
        let dictionaryIdsString = activeDictionaryIds.map { String($0) }.joined(separator: ",")
        
        let randomCount = Int(Double(count) * 0.6)
        let weightedCount = count - randomCount
            
        return try dbQueue.read { db in
            let baseSQL = """
                FROM \(DatabaseWord.databaseTableName)
                WHERE dictionaryId IN (\(dictionaryIdsString))
            """
            
            let randomSQL = """
                SELECT *
                \(baseSQL)
                ORDER BY RANDOM()
                LIMIT \(randomCount)
            """
            
            let weightedSQL = """
                SELECT *
                \(baseSQL)
                ORDER BY weight ASC
                LIMIT \(weightedCount)
            """

            Logger.debug("[WordStorage]: fetchCache - Random SQL: \(randomSQL)")
            Logger.debug("[WordStorage]: fetchCache - Weighted SQL: \(weightedSQL)")
                
            var result = try DatabaseWord.fetchAll(db, sql: randomSQL)
            result.append(contentsOf: try DatabaseWord.fetchAll(db, sql: weightedSQL))
            return result.shuffled()
        }
    }

    func save(_ word: DatabaseWord) throws {
        try dbQueue.write { db in
            try word.insert(db)
        }
        Logger.debug("[WordStorage]: save - Word: '\(word.frontText)'")
    }
    
    func update(_ word: DatabaseWord) throws {
        try dbQueue.write { db in
            try word.update(db)
        }
        Logger.debug("[WordStorage]: update - Word: '\(word.frontText)'")
    }
    
    func delete(_ word: DatabaseWord) throws {
        try dbQueue.write { db in
            try word.delete(db)
        }
        Logger.debug("[WordStorage]: delete - Word: '\(word.frontText)'")
    }
}
