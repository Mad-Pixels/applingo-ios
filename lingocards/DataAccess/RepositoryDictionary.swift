import GRDB

class RepositoryDictionary: DictionaryRepositoryProtocol {
    private let dbQueue: DatabaseQueue
    
    init(dbQueue: DatabaseQueue) {
        self.dbQueue = dbQueue
    }
    
    func fetch(
        searchText: String?,
        offset: Int,
        limit: Int
    ) throws -> [DictionaryItem] {
        return try dbQueue.read { db in
            var sql = "SELECT * FROM \(DictionaryItem.databaseTableName)"
            var arguments: [DatabaseValueConvertible] = []
            
            if let searchText = searchText, !searchText.isEmpty {
                sql += " WHERE displayName LIKE ?"
                arguments.append("%\(searchText)%")
            }
            
            sql += " ORDER BY id ASC LIMIT ? OFFSET ?"
            arguments.append(limit)
            arguments.append(offset)
            
            Logger.debug("[RepositoryDictionary]: fetch - SQL: \(sql), Arguments: \(arguments)")
            return try DictionaryItem.fetchAll(db, sql: sql, arguments: StatementArguments(arguments))
        }
    }
    
    func save(_ dictionary: DictionaryItem) throws {
        try dbQueue.write { db in
            try dictionary.insert(db)
        }
        Logger.debug("[RepositoryDictionary]: save - \(dictionary.displayName) with ID \(dictionary.id ?? -1)")
    }
    
    func update(_ dictionary: DictionaryItem) throws {
        try dbQueue.write { db in
            try dictionary.update(db)
        }
        Logger.debug("[RepositoryDictionary]: update - \(dictionary.displayName) with ID \(dictionary.id ?? -1)")
    }
    
    func updateStatus(dictionaryID: Int, newStatus: Bool) throws {
        try dbQueue.write { db in
            try db.execute(
                sql: "UPDATE \(DictionaryItem.databaseTableName) SET isActive = ? WHERE id = ?",
                arguments: [newStatus, dictionaryID]
            )
        }
        Logger.debug("[RepositoryDictionary]: updateStatus - ID \(dictionaryID) set to isActive = \(newStatus)")
    }
    
    func delete(_ dictionary: DictionaryItem) throws {
        try dbQueue.write { db in
            let wordsDeleteSQL = "DELETE FROM \(WordItem.databaseTableName) WHERE tableName = ?"
            try db.execute(sql: wordsDeleteSQL, arguments: [dictionary.tableName])
            Logger.debug("[RepositoryDictionary]: delete - associated words for tableName \(dictionary.tableName)")
            
            try dictionary.delete(db)
            Logger.debug("[RepositoryDictionary]: delete - \(dictionary.displayName) with ID \(dictionary.id ?? -1)")
        }
    }
}