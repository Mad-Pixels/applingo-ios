import GRDB

/// A manager for handling CRUD operations and advanced queries related to words in the database.
final class DatabaseManagerWord {
    // MARK: - SQL Constants

    private enum SQL {
        /// Query to fetch active dictionaries.
        static let fetchActive = """
            SELECT * FROM \(DatabaseModelDictionary.databaseTableName) 
            WHERE isActive = 1
        """
        
        /// Base query to fetch words.
        static let baseSelect = """
            SELECT * FROM \(DatabaseModelWord.databaseTableName)
        """
        
        /// Query to search words with relevance ordering.
        static let searchSelect = """
            SELECT *, CASE
                WHEN LOWER(frontText) = LOWER(?) OR LOWER(backText) = LOWER(?) THEN 1
                WHEN LOWER(frontText) LIKE LOWER(? || '%') OR LOWER(backText) LIKE LOWER(? || '%') THEN 2
                WHEN LOWER(frontText) LIKE LOWER('%' || ? || '%') OR LOWER(backText) LIKE LOWER('%' || ? || '%') THEN 3
                ELSE 4 END AS relevance
            FROM \(DatabaseModelWord.databaseTableName)
        """
        
        /// Query to fetch cached words with unique constraints and randomization.
        static let cacheSelect = """
            WITH UniqueWords AS (
                SELECT *, ROW_NUMBER() OVER (PARTITION BY frontText, backText ORDER BY weight) as rn
                FROM \(DatabaseModelWord.databaseTableName)
                WHERE dictionary IN (%@)
            )
            SELECT * FROM UniqueWords 
            WHERE rn = 1
            ORDER BY (CASE WHEN RANDOM() < 0.6 THEN RANDOM() ELSE weight END)
            LIMIT ?
        """
    }

    // MARK: - Properties

    private let dbQueue: DatabaseQueue

    // MARK: - Initialization

    /// Initializes the database manager for words.
    /// - Parameter dbQueue: A GRDB database queue instance.
    init(dbQueue: DatabaseQueue) {
        self.dbQueue = dbQueue
    }

    // MARK: - Public Methods

    /// Fetches words from the database.
    func fetch(
        search: String?,
        offset: Int,
        limit: Int
    ) throws -> [DatabaseModelWord] {
        guard limit > 0 else { throw DatabaseError.invalidLimit(limit: limit) }
        guard offset >= 0 else { throw DatabaseError.invalidOffset(offset: offset) }

        let activeDictionaries = try fetchActive()
        guard !activeDictionaries.isEmpty else { throw DatabaseError.emptyActiveDictionaries }

        return try dbQueue.read { db in
            let (sql, arguments) = try buildFetchQuery(
                search: search?.lowercased(),
                activeDictionaries: activeDictionaries,
                limit: limit,
                offset: offset
            )
            
            Logger.debug(
                "[Word]: Fetch executed",
                metadata: [
                    "sql": sql,
                    "arguments": arguments.map { "\($0)" }.joined(separator: ", ")
                ]
            )

            do {
                return try DatabaseModelWord.fetchAll(db, sql: sql, arguments: StatementArguments(arguments))
            } catch {
                throw DatabaseError.csvImportFailed(details: "Failed to fetch words: \(error.localizedDescription)")
            }
        }
    }

    /// Fetches a cache of words for randomized use.
    func fetchCache(count: Int) throws -> [DatabaseModelWord] {
        guard count > 0 else { throw DatabaseError.invalidLimit(limit: count) }

        let activeDictionaries = try fetchActive()
        guard !activeDictionaries.isEmpty else {
            throw DatabaseError.emptyActiveDictionaries
        }

        guard let selectedGroup = Dictionary(grouping: activeDictionaries, by: { $0.subcategory }).randomElement() else {
            throw DatabaseError.csvImportFailed(details: "No valid dictionary groups found")
        }

        let guids = selectedGroup.value.map { $0.guid }
        let placeholders = guids.map { _ in "?" }.joined(separator: ",")
        let sql = String(format: SQL.cacheSelect, placeholders)

        Logger.debug(
            "[Word]: Fetch cache executed",
            metadata: [
                "dictionaryGuids": guids.joined(separator: ", "),
                "sql": sql
            ]
        )

        return try dbQueue.read { db in
            var arguments = guids as [DatabaseValueConvertible]
            arguments.append(count)

            do {
                return try DatabaseModelWord.fetchAll(db, sql: sql, arguments: StatementArguments(arguments))
            } catch {
                throw DatabaseError.csvImportFailed(details: "Failed to fetch cache: \(error.localizedDescription)")
            }
        }
    }

    /// Saves a word into the database.
    func save(_ word: DatabaseModelWord) throws {
        guard isValidWord(word) else {
            throw DatabaseError.invalidWord(details: "Invalid word data provided")
        }
        
        try dbQueue.write { db in
            do {
                try formatWord(word).insert(db)
            } catch let dbError as GRDB.DatabaseError {
                if dbError.resultCode == .SQLITE_CONSTRAINT {
                    throw DatabaseError.duplicateWord(word: word.frontText)
                } else {
                    throw DatabaseError.csvImportFailed(details: "Failed to save word: \(dbError.localizedDescription)")
                }
            } catch {
                throw DatabaseError.csvImportFailed(details: "Failed to save word: \(error.localizedDescription)")
            }
        }
        
        Logger.debug(
            "[Word]: Save executed",
            metadata: [
                "frontText": word.frontText,
                "backText": word.backText,
                "uuid": word.uuid
            ]
        )
    }

    /// Updates an existing word in the database.
    func update(_ word: DatabaseModelWord) throws {
        guard isValidWord(word) else {
            throw DatabaseError.invalidWord(details: "Invalid word data provided")
        }
        
        try dbQueue.write { db in
            do {
                try formatWord(word).update(db)
            } catch let dbError as GRDB.DatabaseError {
                if dbError.resultCode == .SQLITE_CONSTRAINT {
                    throw DatabaseError.duplicateWord(word: word.frontText)
                } else {
                    throw DatabaseError.updateFailed(details: dbError.localizedDescription)
                }
            } catch {
                throw DatabaseError.updateFailed(details: error.localizedDescription)
            }
        }
        
        Logger.debug(
            "[Word]: Update executed",
            metadata: [
                "frontText": word.frontText,
                "backText": word.backText,
                "uuid": word.uuid
            ]
        )
    }

    /// Deletes a word from the database.
    func delete(_ word: DatabaseModelWord) throws {
        guard word.id != nil else {
            throw DatabaseError.invalidWord(details: "Word has no ID")
        }

        try dbQueue.write { db in
            do {
                try word.delete(db)
            } catch {
                throw DatabaseError.deleteFailed(details: error.localizedDescription)
            }
        }

        Logger.debug(
            "[Word]: Delete executed",
            metadata: [
                "frontText": word.frontText,
                "backText": word.backText,
                "uuid": word.uuid
            ]
        )
    }

    // MARK: - Private Methods

    /// Fetches all active dictionaries from the database.
    private func fetchActive() throws -> [DatabaseModelDictionary] {
        try dbQueue.read { db in
            do {
                return try DatabaseModelDictionary.fetchAll(db, sql: SQL.fetchActive)
            } catch {
                throw DatabaseError.csvImportFailed(details: "Failed to fetch active dictionaries: \(error.localizedDescription)")
            }
        }
    }

    /// Formats a word for insertion or update.
    private func formatWord(_ word: DatabaseModelWord) -> DatabaseModelWord {
        var formatted = word
        formatted.fmt()
        return formatted
    }

    /// Validates if a word is suitable for database operations.
    private func isValidWord(_ word: DatabaseModelWord) -> Bool {
        !word.frontText.isEmpty &&
        !word.backText.isEmpty &&
        !word.dictionary.isEmpty
    }

    /// Builds a fetch query with dynamic conditions.
    private func buildFetchQuery(
        search: String?,
        activeDictionaries: [DatabaseModelDictionary],
        limit: Int,
        offset: Int
    ) throws -> (String, [DatabaseValueConvertible]) {
        var sql: String
        var arguments: [DatabaseValueConvertible] = []
        var conditions: [String] = []

        let activeGuids = activeDictionaries.map { $0.guid } as [DatabaseValueConvertible]
        let placeholders = activeGuids.map { _ in "?" }.joined(separator: ", ")
        conditions.append("dictionary IN (\(placeholders))")
        arguments.append(contentsOf: activeGuids)

        if let trimmedSearch = search?.trimmingCharacters(in: .whitespacesAndNewlines),
           !trimmedSearch.isEmpty {
            let relevanceArgs = Array(repeating: trimmedSearch, count: 6)
            arguments = relevanceArgs + arguments

            conditions.append("(LOWER(frontText) LIKE ? OR LOWER(backText) LIKE ?)")
            arguments.append("%\(trimmedSearch)%")
            arguments.append("%\(trimmedSearch)%")

            sql = SQL.searchSelect
            sql += " WHERE " + conditions.joined(separator: " AND ")
            sql += " ORDER BY relevance ASC, id ASC"
        } else {
            sql = SQL.baseSelect
            sql += " WHERE " + conditions.joined(separator: " AND ")
            sql += " ORDER BY id ASC"
        }

        sql += " LIMIT ? OFFSET ?"
        arguments.append(limit)
        arguments.append(offset)

        return (sql, arguments)
    }
}
