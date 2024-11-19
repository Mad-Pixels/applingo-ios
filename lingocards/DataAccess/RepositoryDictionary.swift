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
    ) throws -> [DictionaryItemModel] {
        return try dbQueue.read { db in
            var sql = "SELECT * FROM \(DictionaryItemModel.databaseTableName)"
            var arguments: [DatabaseValueConvertible] = []
            
            if let searchText = searchText, !searchText.isEmpty {
                sql += " WHERE displayName LIKE ?"
                arguments.append("%\(searchText)%")
            }
            sql += " ORDER BY id ASC LIMIT ? OFFSET ?"
            arguments.append(limit)
            arguments.append(offset)
            
            Logger.debug("[RepositoryDictionary]: fetch - SQL: \(sql), Arguments: \(arguments)")
            return try DictionaryItemModel.fetchAll(db, sql: sql, arguments: StatementArguments(arguments))
        }
    }
    
    func fetchDisplayName(byTableName tableName: String) throws -> String {
        return try dbQueue.read { db in
            let sql = """
            SELECT displayName FROM \(DictionaryItemModel.databaseTableName)
            WHERE tableName = ?
            """
            let arguments: [DatabaseValueConvertible] = [tableName]
            
            Logger.debug("[RepositoryDictionary]: getDisplayName - SQL: \(sql), Arguments: \(arguments)")
            return try String.fetchOne(db, sql: sql, arguments: StatementArguments(arguments)) ?? ""
        }
    }
    
    func save(_ dictionary: DictionaryItemModel) throws {
        var fmtDictionary = dictionary
        fmtDictionary.fmt()
        
        try dbQueue.write { db in
            try fmtDictionary.insert(db)
        }
        Logger.debug("[RepositoryDictionary]: save - \(dictionary.displayName) with ID \(dictionary.id ?? -1)")
    }
    
    func update(_ dictionary: DictionaryItemModel) throws {
        var fmtDictionary = dictionary
        fmtDictionary.fmt()
        
        try dbQueue.write { db in
            try fmtDictionary.update(db)
        }
        Logger.debug("[RepositoryDictionary]: update - \(dictionary.displayName) with ID \(dictionary.id ?? -1)")
    }
    
    func updateStatus(dictionaryID: Int, newStatus: Bool) throws {
        try dbQueue.write { db in
            try db.execute(
                sql: "UPDATE \(DictionaryItemModel.databaseTableName) SET isActive = ? WHERE id = ?",
                arguments: [newStatus, dictionaryID]
            )
        }
        Logger.debug("[RepositoryDictionary]: updateStatus - ID \(dictionaryID) set to isActive = \(newStatus)")
    }
    
    func delete(_ dictionary: DictionaryItemModel) throws {
        try dbQueue.write { db in
            let wordsDeleteSQL = "DELETE FROM \(WordItemModel.databaseTableName) WHERE tableName = ?"
            try db.execute(sql: wordsDeleteSQL, arguments: [dictionary.tableName])
            Logger.debug("[RepositoryDictionary]: delete - associated words for tableName \(dictionary.tableName)")
            
            try dictionary.delete(db)
            Logger.debug("[RepositoryDictionary]: delete - \(dictionary.displayName) with ID \(dictionary.id ?? -1)")
        }
    }
}
