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
    ) throws -> [DatabaseModelDictionary] {
        return try dbQueue.read { db in
            var sql = "SELECT * FROM \(DatabaseModelDictionary.databaseTableName)"
            var arguments: [DatabaseValueConvertible] = []
            
            if let searchText = searchText, !searchText.isEmpty {
                sql += " WHERE name LIKE ?"
                arguments.append("%\(searchText)%")
            }
            sql += " ORDER BY id ASC LIMIT ? OFFSET ?"
            arguments.append(limit)
            arguments.append(offset)
            
            Logger.debug("[RepositoryDictionary]: fetch - SQL: \(sql), Arguments: \(arguments)")
            return try DatabaseModelDictionary.fetchAll(db, sql: sql, arguments: StatementArguments(arguments))
        }
    }
    
    func fetchDisplayName(byTableName tableName: String) throws -> String {
        return try dbQueue.read { db in
            let sql = """
            SELECT name FROM \(DatabaseModelDictionary.databaseTableName)
            WHERE tableName = ?
            """
            let arguments: [DatabaseValueConvertible] = [tableName]
            
            Logger.debug("[RepositoryDictionary]: getDisplayName - SQL: \(sql), Arguments: \(arguments)")
            return try String.fetchOne(db, sql: sql, arguments: StatementArguments(arguments)) ?? ""
        }
    }
    
    func save(_ dictionary: DatabaseModelDictionary) throws {
        var fmtDictionary = dictionary
        fmtDictionary.fmt()
        
        try dbQueue.write { db in
            try fmtDictionary.insert(db)
        }
        Logger.debug("[RepositoryDictionary]: save - \(dictionary.name) with ID \(dictionary.id)")
    }
    
    func update(_ dictionary: DatabaseModelDictionary) throws {
        var fmtDictionary = dictionary
        fmtDictionary.fmt()
        
        try dbQueue.write { db in
            try fmtDictionary.update(db)
        }
        Logger.debug("[RepositoryDictionary]: update - \(dictionary.name) with ID \(dictionary.id)")
    }
    
    func updateStatus(dictionaryID: Int, newStatus: Bool) throws {
        try dbQueue.write { db in
            try db.execute(
                sql: "UPDATE \(DatabaseModelDictionary.databaseTableName) SET isActive = ? WHERE id = ?",
                arguments: [newStatus, dictionaryID]
            )
        }
        Logger.debug("[RepositoryDictionary]: updateStatus - ID \(dictionaryID) set to isActive = \(newStatus)")
    }
    
    func delete(_ dictionary: DatabaseModelDictionary) throws {
        try dbQueue.write { db in
            let wordsDeleteSQL = "DELETE FROM \(WordItemModel.databaseTableName) WHERE tableName = ?"
            try db.execute(sql: wordsDeleteSQL, arguments: [dictionary.guid])
            Logger.debug("[RepositoryDictionary]: delete - associated words for tableName \(dictionary.guid)")
            
            try dictionary.delete(db)
            Logger.debug("[RepositoryDictionary]: delete - \(dictionary.name) with ID \(dictionary.id)")
        }
    }
}
