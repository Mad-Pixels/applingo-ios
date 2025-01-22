import GRDB

final class Dictionary {
    private let dbQueue: DatabaseQueue
    
    init(dbQueue: DatabaseQueue) {
        self.dbQueue = dbQueue
    }
    
    func fetch(
        searchText: String?,
        offset: Int,
        limit: Int
    ) throws -> [DatabaseDictionary] {
        return try dbQueue.read { db in
            var sql = "SELECT * FROM \(DatabaseDictionary.databaseTableName)"
            var arguments: [DatabaseValueConvertible] = []
            
            if let searchText = searchText, !searchText.isEmpty {
                sql += " WHERE name LIKE ? OR author LIKE ? OR description LIKE ?"
                arguments.append("%\(searchText)%")
                arguments.append("%\(searchText)%")
                arguments.append("%\(searchText)%")
            }
            
            sql += " ORDER BY created DESC LIMIT ? OFFSET ?"
            arguments.append(limit)
            arguments.append(offset)
            
            Logger.debug("[DictionaryStorage]: fetch - SQL: \(sql), Arguments: \(arguments)")
            return try DatabaseDictionary.fetchAll(db, sql: sql, arguments: StatementArguments(arguments))
        }
    }
    
    func fetchName(byUniq uniq: String) throws -> String {
        return try dbQueue.read { db in
            let sql = """
            SELECT name FROM \(DatabaseDictionary.databaseTableName)
            WHERE uniq = ?
            """
            let arguments: [DatabaseValueConvertible] = [uniq]
            
            Logger.debug("[DictionaryStorage]: getName - SQL: \(sql), Arguments: \(arguments)")
            return try String.fetchOne(db, sql: sql, arguments: StatementArguments(arguments)) ?? ""
        }
    }
    
    func save(_ dictionary: DatabaseDictionary) throws {
        try dbQueue.write { db in
            try dictionary.insert(db)
        }
        Logger.debug("[DictionaryStorage]: save - \(dictionary.name) with ID \(dictionary.id)")
    }
    
    func update(_ dictionary: DatabaseDictionary) throws {
        try dbQueue.write { db in
            try dictionary.update(db)
        }
        Logger.debug("[DictionaryStorage]: update - \(dictionary.name) with ID \(dictionary.id)")
    }
    
    func updateActive(id: Int, active: Bool) throws {
        try dbQueue.write { db in
            try db.execute(
                sql: "UPDATE \(DatabaseDictionary.databaseTableName) SET active = ? WHERE id = ?",
                arguments: [active, id]
            )
        }
        Logger.debug("[DictionaryStorage]: updateActive - ID \(id) set to active = \(active)")
    }
    
    func delete(_ dictionary: DatabaseDictionary) throws {
        try dbQueue.write { db in
            let wordsDeleteSQL = "DELETE FROM \(DatabaseWord.databaseTableName) WHERE uniq = ?"
            try db.execute(sql: wordsDeleteSQL, arguments: [dictionary.uniq])
            Logger.debug("[DictionaryStorage]: delete - associated words for uniq \(dictionary.uniq)")
            
            try dictionary.delete(db)
            Logger.debug("[DictionaryStorage]: delete - \(dictionary.name) with ID \(dictionary.id)")
        }
    }
}
