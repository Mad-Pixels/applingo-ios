import GRDB

/// A manager for handling CRUD operations and advanced queries related to dictionaries in the database.
final class DatabaseManagerDictionary {
    // MARK: - SQL Constants

    private enum SQL {
        /// Base query to fetch dictionaries.
        static let fetch = """
            SELECT * FROM \(DatabaseModelDictionary.databaseTableName)
            WHERE 1=1
        """
        
        /// Query to add search conditions for dictionaries.
        static let search = """
            AND (name LIKE ? 
            OR author LIKE ? 
            OR description LIKE ?)
        """
        
        /// Query to fetch the name of a dictionary by its GUID.
        static let fetchName = """
            SELECT name 
            FROM \(DatabaseModelDictionary.databaseTableName)
            WHERE guid = ?
        """
        
        /// Query to delete all words related to a specific dictionary.
        static let deleteWords = """
            DELETE FROM \(DatabaseModelWord.databaseTableName) 
            WHERE dictionary = ?
        """
        
        /// Query to update the `isActive` status of a dictionary.
        static let updateStatus = """
            UPDATE \(DatabaseModelDictionary.databaseTableName) 
            SET isActive = ? 
            WHERE id = ?
        """
        
        /// Query to count words in a specific dictionary.
        static let countWords = """
            SELECT COUNT(*) 
            FROM \(DatabaseModelWord.databaseTableName) 
            WHERE dictionary = ?
        """
    }

    // MARK: - Properties

    private let dbQueue: DatabaseQueue

    // MARK: - Initialization

    /// Initializes the database manager for dictionaries.
    /// - Parameter dbQueue: A GRDB database queue instance.
    init(dbQueue: DatabaseQueue) {
        self.dbQueue = dbQueue
    }

    // MARK: - Public Methods

    /// Fetches dictionaries from the database.
    /// - Parameters:
    ///   - search: A search string for filtering dictionaries.
    ///   - offset: The offset for pagination.
    ///   - limit: The limit for pagination.
    /// - Throws: `DatabaseError` if there are validation issues or query failures.
    /// - Returns: An array of `DatabaseModelDictionary`.
    func fetch(search: String?, offset: Int, limit: Int) throws -> [DatabaseModelDictionary] {
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
                "[Dictionary]: fetch",
                metadata: ["sql": sql, "arguments": arguments]
            )
            do {
                return try DatabaseModelDictionary.fetchAll(db, sql: sql, arguments: StatementArguments(arguments))
            } catch {
                throw DatabaseError.csvImportFailed("Failed to fetch dictionaries: \(error.localizedDescription)")
            }
        }
    }

    /// Fetches the name of a dictionary by its table name.
    /// - Parameter tableName: The table name of the dictionary.
    /// - Throws: `DatabaseError` if the table name is invalid or query fails.
    /// - Returns: The name of the dictionary.
    func fetchName(byTableName tableName: String) throws -> String {
        guard !tableName.isEmpty else {
            throw DatabaseError.invalidSearchParameters
        }
        
        return try dbQueue.read { db in
            Logger.debug(
                "[Dictionary]: fetchName",
                metadata: ["tableName": tableName]
            )
            do {
                return try String.fetchOne(db, sql: SQL.fetchName, arguments: [tableName]) ?? ""
            } catch {
                throw DatabaseError.csvImportFailed("Failed to fetch display name: \(error.localizedDescription)")
            }
        }
    }

    /// Saves a dictionary into the database.
    /// - Parameter dictionary: A `DatabaseModelDictionary` instance to save.
    /// - Throws: `DatabaseError` if the dictionary is invalid or the save fails.
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
            "[Dictionary]: Save executed",
            metadata: [
                "id": dictionary.id ?? -1,
                "giud": dictionary.guid,
                "name": dictionary.name
            ]
        )
    }

    /// Updates an existing dictionary in the database.
    /// - Parameter dictionary: A `DatabaseModelDictionary` instance to update.
    /// - Throws: `DatabaseError` if the dictionary is invalid or the update fails.
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
            "[Dictionary]: Update executed",
            metadata: [
                "id": dictionary.id ?? -1,
                "giud": dictionary.guid,
                "name": dictionary.name
            ]
        )
    }

    /// Updates the active status of a dictionary.
    /// - Parameters:
    ///   - dictionaryID: The ID of the dictionary.
    ///   - newStatus: The new active status.
    /// - Throws: `DatabaseError` if the dictionary ID is invalid or the update fails.
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
            "[Dictionary]: Update Status executed",
            metadata: [
                "dictionaryID": dictionaryID,
                "newStatus": newStatus
            ]
        )
    }

    /// Counts the number of words in a dictionary.
    /// - Parameter dictionary: The dictionary for which to count words.
    /// - Throws: `DatabaseError` if the dictionary is invalid or the query fails.
    /// - Returns: The count of words in the dictionary.
    func count(forDictionary dictionary: DatabaseModelDictionary) throws -> Int {
        guard !dictionary.guid.isEmpty else {
            throw DatabaseError.invalidWord("Dictionary has no GUID")
        }
        
        return try dbQueue.read { db in
            Logger.debug(
                "[Dictionary]: Count words executed",
                metadata: [
                    "id": dictionary.id ?? -1,
                    "giud": dictionary.guid,
                    "name": dictionary.name
                ]
            )
            do {
                return try Int.fetchOne(db, sql: SQL.countWords, arguments: [dictionary.guid]) ?? 0
            } catch {
                throw DatabaseError.csvImportFailed("Failed to count words: \(error.localizedDescription)")
            }
        }
    }

    /// Deletes a dictionary from the database.
    /// - Parameter dictionary: A `DatabaseModelDictionary` instance to delete.
    /// - Throws: `DatabaseError` if the dictionary is invalid or the deletion fails.
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
            "[Dictionary]: Delete executed",
            metadata: [
                "id": dictionary.id ?? -1,
                "giud": dictionary.guid,
                "name": dictionary.name
            ]
        )
    }

    // MARK: - Private Methods

    /// Formats a dictionary for insertion or update.
    /// - Parameter dictionary: A `DatabaseModelDictionary` instance.
    /// - Returns: A formatted `DatabaseModelDictionary`.
    private func formatDictionary(_ dictionary: DatabaseModelDictionary) -> DatabaseModelDictionary {
        var formatted = dictionary
        formatted.fmt()
        return formatted
    }

    /// Validates if a dictionary is suitable for database operations.
    /// - Parameter dictionary: A `DatabaseModelDictionary` instance.
    /// - Returns: `true` if the dictionary is valid, otherwise `false`.
    private func isValidDictionary(_ dictionary: DatabaseModelDictionary) -> Bool {
        !dictionary.name.isEmpty && !dictionary.guid.isEmpty
    }
}
