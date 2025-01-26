import GRDB

final class DatabaseManagerDictionary {
    // MARK: - Constants
    private enum SQL {
        static let fetch = """
            SELECT * FROM \(DatabaseModelDictionary.databaseTableName)
            WHERE 1=1
        """
        
        static let search = """
            AND (name LIKE ? 
            OR author LIKE ? 
            OR description LIKE ?)
        """
        
        static let fetchName = """
            SELECT name 
            FROM \(DatabaseModelDictionary.databaseTableName)
            WHERE guid = ?
        """
        
        static let deleteWords = """
            DELETE FROM \(DatabaseModelWord.databaseTableName) 
            WHERE dictionary = ?
        """
        
        static let updateStatus = """
            UPDATE \(DatabaseModelDictionary.databaseTableName) 
            SET isActive = ? 
            WHERE id = ?
        """
    }

    private let dbQueue: DatabaseQueue
    
    init(dbQueue: DatabaseQueue) {
        self.dbQueue = dbQueue
    }
    
    func fetch(
        search: String?,
        offset: Int,
        limit: Int
    ) throws -> [DatabaseModelDictionary] {
        guard limit > 0 else { throw DatabaseError.invalidLimit(limit) }
        guard offset >= 0 else { throw DatabaseError.invalidOffset(offset) }
        
        return try dbQueue.read { db in
            var arguments: [DatabaseValueConvertible] = []
            var sql = SQL.fetch
            
            if let search = search, !search.isEmpty {
                sql += SQL.search
                arguments += ["%\(search)%", "%\(search)%", "%\(search)%"]
            }
            
            sql += " ORDER BY id ASC LIMIT ? OFFSET ?"
            arguments += [limit, offset]
            
            Logger.debug(
                "[Dictionary]: fetch - SQL: \(sql), Arguments: \(arguments)"
            )
            do {
                return try DatabaseModelDictionary.fetchAll(db, sql: sql, arguments: StatementArguments(arguments))
            } catch {
                throw DatabaseError.csvImportFailed("Failed to fetch dictionaries: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchName(byTableName tableName: String) throws -> String {
        guard !tableName.isEmpty else {
            throw DatabaseError.invalidSearchParameters
        }
        
        return try dbQueue.read { db in
            Logger.debug(
                "[Dictionary]: getDisplayName - SQL: \(SQL.fetchName), Arguments: [\(tableName)]"
            )
            do {
                return try String.fetchOne(db, sql: SQL.fetchName, arguments: [tableName]) ?? ""
            } catch {
                throw DatabaseError.csvImportFailed("Failed to fetch display name: \(error.localizedDescription)")
            }
        }
    }
    
    func save(_ dictionary: DatabaseModelDictionary) throws {
        guard isValidDictionary(dictionary) else {
            throw DatabaseError.invalidWord("Invalid dictionary data")
        }
        
        let formattedDictionary = formatDictionary(dictionary)
        try dbQueue.write { db in
            do {
                try formattedDictionary.insert(db)
            } catch {
                throw DatabaseError.csvImportFailed("Failed to save dictionary: \(error.localizedDescription)")
            }
        }
        Logger.debug(
            "[Dictionary]: save - \(dictionary.name) with ID \(String(describing: dictionary.id))"
        )
    }
    
    func update(_ dictionary: DatabaseModelDictionary) throws {
        guard isValidDictionary(dictionary) else {
            throw DatabaseError.invalidWord("Invalid dictionary data")
        }
        
        let formattedDictionary = formatDictionary(dictionary)
        try dbQueue.write { db in
            do {
                try formattedDictionary.update(db)
            } catch {
                throw DatabaseError.updateFailed("Failed to update dictionary: \(error.localizedDescription)")
            }
        }
        Logger.debug(
            "[Dictionary]: update - \(dictionary.name) with ID \(String(describing: dictionary.id))"
        )
    }
    
    func updateStatus(dictionaryID: Int, newStatus: Bool) throws {
        guard dictionaryID > 0 else {
            throw DatabaseError.invalidWord("Invalid dictionary ID")
        }
        
        try dbQueue.write { db in
            do {
                try db.execute(sql: SQL.updateStatus, arguments: [newStatus, dictionaryID])
            } catch {
                throw DatabaseError.updateFailed("Failed to update dictionary status: \(error.localizedDescription)")
            }
        }
        Logger.debug(
            "[Dictionary]: updateStatus - ID \(dictionaryID) set to isActive = \(newStatus)"
        )
    }
    
    func delete(_ dictionary: DatabaseModelDictionary) throws {
        guard dictionary.id != nil else {
            throw DatabaseError.invalidWord("Dictionary has no ID")
        }
        
        try dbQueue.write { db in
            do {
                try db.execute(sql: SQL.deleteWords, arguments: [dictionary.guid])
                try dictionary.delete(db)
            } catch {
                throw DatabaseError.deleteFailed("Failed to delete dictionary: \(error.localizedDescription)")
            }
        }
        Logger.debug(
            "[Dictionary]: delete - \(dictionary.name) with ID \(String(describing: dictionary.id))"
        )
    }
    
    private func formatDictionary(_ dictionary: DatabaseModelDictionary) -> DatabaseModelDictionary {
        var formatted = dictionary
        formatted.fmt()
        return formatted
    }
    
    private func isValidDictionary(_ dictionary: DatabaseModelDictionary) -> Bool {
        !dictionary.name.isEmpty && !dictionary.guid.isEmpty
    }
}
