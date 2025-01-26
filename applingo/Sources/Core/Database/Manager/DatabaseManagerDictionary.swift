import GRDB

class DatabaseManagerDictionary {
    private let dbQueue: DatabaseQueue
    
    init(dbQueue: DatabaseQueue) {
        self.dbQueue = dbQueue
    }
   
    func fetch(
        search: String?,
        offset: Int,
        limit: Int
    ) throws -> [
        DatabaseModelDictionary
    ] {
        return try dbQueue.read { db in
            var sql = "SELECT * FROM \(DatabaseModelDictionary.databaseTableName)"
            var arguments: [DatabaseValueConvertible] = []
           
            if let search = search, !search.isEmpty {
                sql += """
                    WHERE name LIKE ? 
                    OR author LIKE ? 
                    OR description LIKE ?
                """
                arguments += [
                    "%\(search)%",
                    "%\(search)%",
                    "%\(search)%"
                ]
            }
            
            sql += " ORDER BY id ASC LIMIT ? OFFSET ?"
            arguments.append(limit)
            arguments.append(offset)
           
            Logger.debug("[RepositoryDictionary]: fetch - SQL: \(sql), Arguments: \(arguments)")
            return try DatabaseModelDictionary.fetchAll(db, sql: sql, arguments: StatementArguments(arguments))
        }
    }

    func fetchDisplayName(byTableName tableName: String) throws -> String {
        try dbQueue.read { db in
            let sql = """
            SELECT \(Column("name")) 
            FROM \(DatabaseModelDictionary.databaseTableName)
            WHERE \(Column("guid")) = ?
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
        Logger.debug("[RepositoryDictionary]: save - \(dictionary.name) with ID \(String(describing: dictionary.id))")
    }
   
    func update(_ dictionary: DatabaseModelDictionary) throws {
        var fmtDictionary = dictionary
        fmtDictionary.fmt()
       
        try dbQueue.write { db in
            try fmtDictionary.update(db)
        }
        Logger.debug("[RepositoryDictionary]: update - \(dictionary.name) with ID \(String(describing: dictionary.id))")
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
            try db.execute(sql: """
                DELETE FROM \(DatabaseModelWord.databaseTableName) 
                WHERE \(Column("dictionary")) = ?
            """, arguments: [dictionary.guid])
            
            try dictionary.delete(db)
        }
        Logger.debug("[RepositoryDictionary]: delete - \(dictionary.name) with ID \(String(describing: dictionary.id))")
    }
}
