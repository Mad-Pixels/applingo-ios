import GRDB

/// A manager for handling CRUD operations and advanced queries related to dictionaries in the database.
/// Implements prioritized search with relevance ranking and case-insensitive matching.
final class DatabaseManagerDictionary {
    // MARK: - SQL Constants
    
    private enum SQL {
        /// Base query for dictionary fetching
        static let fetch = """
            SELECT * FROM \(DatabaseModelDictionary.databaseTableName)
            WHERE 1=1
        """
        
        /// Prioritized search query with relevance ranking
        /// Priorities:
        /// 1. Exact name match
        /// 2. Name starts with search term
        /// 3. Name contains search term
        /// 4. Author contains search term
        /// 5. Description contains search term
        static let search = """
            AND (
                CASE
                    WHEN name = ? COLLATE NOCASE THEN 1
                    WHEN name LIKE (? || '%') COLLATE NOCASE THEN 2
                    WHEN name LIKE ('%' || ? || '%') COLLATE NOCASE THEN 3
                    WHEN author LIKE ('%' || ? || '%') COLLATE NOCASE THEN 4
                    WHEN description LIKE ('%' || ? || '%') COLLATE NOCASE THEN 5
                    ELSE 6
                END
            ) < 6
        """

        static let searchOrder = """
            ORDER BY
                CASE
                    WHEN name = ? COLLATE NOCASE THEN 1
                    WHEN name LIKE (? || '%') COLLATE NOCASE THEN 2
                    WHEN name LIKE ('%' || ? || '%') COLLATE NOCASE THEN 3
                    WHEN author LIKE ('%' || ? || '%') COLLATE NOCASE THEN 4
                    WHEN description LIKE ('%' || ? || '%') COLLATE NOCASE THEN 5
                    ELSE 6
                END,
                name COLLATE NOCASE ASC
        """
        
        /// Query to fetch dictionary name by GUID
        static let fetchName = """
            SELECT name 
            FROM \(DatabaseModelDictionary.databaseTableName)
            WHERE guid = ?
        """
        
        /// Query to delete words from a dictionary
        static let deleteWords = """
            DELETE FROM \(DatabaseModelWord.databaseTableName) 
            WHERE dictionary = ?
        """
        
        /// Query to update dictionary status
        static let updateStatus = """
            UPDATE \(DatabaseModelDictionary.databaseTableName) 
            SET isActive = ? 
            WHERE id = ?
        """
        
        /// Query to count words in a dictionary
        static let countWords = """
            SELECT COUNT(*) 
            FROM \(DatabaseModelWord.databaseTableName) 
            WHERE dictionary = ?
        """
    }
    
    // MARK: - Properties
    
    private let dbQueue: DatabaseQueue
    
    // MARK: - Initialization
    
    /// Initializes the database manager for dictionaries
    /// - Parameter dbQueue: A GRDB database queue instance
    init(dbQueue: DatabaseQueue) {
        self.dbQueue = dbQueue
        Logger.info("[Dictionary]: DatabaseManagerDictionary initialized")
    }
    
    // MARK: - Public Methods
    
    /// Fetches dictionaries with prioritized search and pagination
    /// - Parameters:
    ///   - search: Optional search string for filtering
    ///   - offset: Offset for pagination
    ///   - limit: Maximum number of items to fetch
    /// - Returns: Array of matching dictionaries, ordered by relevance
    func fetch(search: String?, offset: Int, limit: Int) throws -> [DatabaseModelDictionary] {
        guard limit > 0 else {
            Logger.error("[Dictionary]: Invalid limit", metadata: ["limit": String(limit)])
            throw DatabaseError.invalidLimit(limit)
        }
        guard offset >= 0 else {
            Logger.error("[Dictionary]: Invalid offset", metadata: ["offset": String(offset)])
            throw DatabaseError.invalidOffset(offset)
        }
        
        Logger.debug(
            "[Dictionary]: Starting fetch",
            metadata: [
                "search": search ?? "nil",
                "offset": String(offset),
                "limit": String(limit)
            ]
        )
        
        return try dbQueue.read { db in
            var arguments: [DatabaseValueConvertible] = []
            var sql = SQL.fetch
            
            if let search = search?.trimmingCharacters(in: .whitespacesAndNewlines), !search.isEmpty {
                sql += SQL.search
                // Arguments for WHERE clause search conditions
                arguments += [search] // Exact match
                arguments += [search] // Starts with
                arguments += [search] // Contains in name
                arguments += [search] // Contains in author
                arguments += [search] // Contains in description
                
                sql += SQL.searchOrder
                // Arguments for ORDER BY clause (same conditions)
                arguments += [search, search, search, search, search]
                
                Logger.debug(
                    "[Dictionary]: Applying search filter",
                    metadata: [
                        "searchTerm": search,
                        "argumentsCount": String(arguments.count)
                    ]
                )
            } else {
                sql += " ORDER BY name ASC"
            }
            
            sql += " LIMIT ? OFFSET ?"
            arguments += [limit, offset]
            
            do {
                let dictionaries = try DatabaseModelDictionary.fetchAll(
                    db,
                    sql: sql,
                    arguments: StatementArguments(arguments)
                )
                
                Logger.info(
                    "[Dictionary]: Fetch completed",
                    metadata: [
                        "count": String(dictionaries.count),
                        "hasSearch": String(search != nil)
                    ]
                )
                return dictionaries
            } catch {
                Logger.error(
                    "[Dictionary]: Fetch failed",
                    metadata: ["error": error.localizedDescription]
                )
                throw DatabaseError.csvImportFailed("Failed to fetch dictionaries: \(error.localizedDescription)")
            }
        }
    }
    
    /// Fetches dictionary name by its table name
    /// - Parameter tableName: The table name to look up
    /// - Returns: The dictionary name or empty string
    func fetchName(byTableName tableName: String) throws -> String {
        guard !tableName.isEmpty else {
            Logger.error("[Dictionary]: Empty table name")
            throw DatabaseError.invalidSearchParameters
        }
        
        Logger.debug(
            "[Dictionary]: Fetching name",
            metadata: ["tableName": tableName]
        )
        
        return try dbQueue.read { db in
            do {
                let name = try String.fetchOne(db, sql: SQL.fetchName, arguments: [tableName]) ?? ""
                Logger.info(
                    "[Dictionary]: Name fetched",
                    metadata: [
                        "tableName": tableName,
                        "name": name
                    ]
                )
                return name
            } catch {
                Logger.error(
                    "[Dictionary]: Failed to fetch name",
                    metadata: ["error": error.localizedDescription]
                )
                throw DatabaseError.csvImportFailed("Failed to fetch display name: \(error.localizedDescription)")
            }
        }
    }
    
    /// Saves a new dictionary
    /// - Parameter dictionary: The dictionary to save
    func save(_ dictionary: DatabaseModelDictionary) throws {
        guard isValidDictionary(dictionary) else {
            Logger.error(
                "[Dictionary]: Invalid dictionary",
                metadata: ["dictionary": dictionary.toString()]
            )
            throw DatabaseError.invalidWord("Invalid dictionary data")
        }
        
        let formattedDictionary = formatDictionary(dictionary)
        
        try dbQueue.write { db in
            do {
                try formattedDictionary.insert(db)
                Logger.info(
                    "[Dictionary]: Dictionary saved",
                    metadata: [
                        "id": formattedDictionary.id ?? -1,
                        "guid": formattedDictionary.guid,
                        "name": formattedDictionary.name
                    ]
                )
            } catch {
                Logger.error(
                    "[Dictionary]: Save failed",
                    metadata: ["error": error.localizedDescription]
                )
                throw DatabaseError.csvImportFailed("Failed to save dictionary: \(error.localizedDescription)")
            }
        }
    }
    
    /// Updates an existing dictionary
    /// - Parameter dictionary: The dictionary to update
    func update(_ dictionary: DatabaseModelDictionary) throws {
        guard isValidDictionary(dictionary) else {
            Logger.error(
                "[Dictionary]: Invalid dictionary for update",
                metadata: ["dictionary": dictionary.toString()]
            )
            throw DatabaseError.invalidWord("Invalid dictionary data")
        }
        
        let formattedDictionary = formatDictionary(dictionary)
        
        try dbQueue.write { db in
            do {
                try formattedDictionary.update(db)
                Logger.info(
                    "[Dictionary]: Dictionary updated",
                    metadata: [
                        "id": formattedDictionary.id ?? -1,
                        "guid": formattedDictionary.guid,
                        "name": formattedDictionary.name
                    ]
                )
            } catch {
                Logger.error(
                    "[Dictionary]: Update failed",
                    metadata: ["error": error.localizedDescription]
                )
                throw DatabaseError.updateFailed("Failed to update dictionary: \(error.localizedDescription)")
            }
        }
    }
    
    /// Updates dictionary active status
    /// - Parameters:
    ///   - dictionaryID: ID of the dictionary
    ///   - newStatus: New active status
    func updateStatus(dictionaryID: Int, newStatus: Bool) throws {
        guard dictionaryID > 0 else {
            Logger.error(
                "[Dictionary]: Invalid dictionary ID",
                metadata: ["dictionaryID": String(dictionaryID)]
            )
            throw DatabaseError.invalidWord("Invalid dictionary ID")
        }
        
        try dbQueue.write { db in
            do {
                try db.execute(sql: SQL.updateStatus, arguments: [newStatus, dictionaryID])
                Logger.info(
                    "[Dictionary]: Status updated",
                    metadata: [
                        "dictionaryID": String(dictionaryID),
                        "newStatus": String(newStatus)
                    ]
                )
            } catch {
                Logger.error(
                    "[Dictionary]: Status update failed",
                    metadata: ["error": error.localizedDescription]
                )
                throw DatabaseError.updateFailed("Failed to update dictionary status: \(error.localizedDescription)")
            }
        }
    }
    
    /// Counts words in a dictionary
    /// - Parameter dictionary: The dictionary to count words for
    /// - Returns: Number of words in the dictionary
    func count(forDictionary dictionary: DatabaseModelDictionary) throws -> Int {
        guard !dictionary.guid.isEmpty else {
            Logger.error(
                "[Dictionary]: Empty GUID",
                metadata: ["dictionary": dictionary.toString()]
            )
            throw DatabaseError.invalidWord("Dictionary has no GUID")
        }
        
        return try dbQueue.read { db in
            do {
                let count = try Int.fetchOne(db, sql: SQL.countWords, arguments: [dictionary.guid]) ?? 0
                Logger.info(
                    "[Dictionary]: Words counted",
                    metadata: [
                        "dictionary": dictionary.name,
                        "count": String(count)
                    ]
                )
                return count
            } catch {
                Logger.error(
                    "[Dictionary]: Count failed",
                    metadata: ["error": error.localizedDescription]
                )
                throw DatabaseError.csvImportFailed("Failed to count words: \(error.localizedDescription)")
            }
        }
    }
    
    /// Deletes a dictionary and its words
    /// - Parameter dictionary: The dictionary to delete
    func delete(_ dictionary: DatabaseModelDictionary) throws {
        guard let id = dictionary.id else {
            Logger.error(
                "[Dictionary]: Missing ID for delete",
                metadata: ["dictionary": dictionary.toString()]
            )
            throw DatabaseError.invalidWord("Dictionary has no ID")
        }
        
        try dbQueue.write { db in
            do {
                try db.execute(sql: SQL.deleteWords, arguments: [dictionary.guid])
                try dictionary.delete(db)
                Logger.info(
                    "[Dictionary]: Dictionary and words deleted",
                    metadata: [
                        "id": String(id),
                        "guid": dictionary.guid,
                        "name": dictionary.name
                    ]
                )
            } catch {
                Logger.error(
                    "[Dictionary]: Delete failed",
                    metadata: ["error": error.localizedDescription]
                )
                throw DatabaseError.deleteFailed("Failed to delete dictionary: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Private Methods
    
    /// Formats dictionary data for database operations
    private func formatDictionary(_ dictionary: DatabaseModelDictionary) -> DatabaseModelDictionary {
        var formatted = dictionary
        formatted.fmt()
        return formatted
    }
    
    /// Validates dictionary data
    private func isValidDictionary(_ dictionary: DatabaseModelDictionary) -> Bool {
        !dictionary.name.isEmpty && !dictionary.guid.isEmpty
    }
}
