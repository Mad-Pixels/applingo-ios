import GRDB

final class DatabaseManagerWord {
    // MARK: - Constants
    private enum SQL {
        static let fetchActive = """
            SELECT * FROM \(DatabaseModelDictionary.databaseTableName) 
            WHERE isActive = 1
        """
        
        static let baseSelect = """
            SELECT * FROM \(DatabaseModelWord.databaseTableName)
        """
        
        static let searchSelect = """
            SELECT *, CASE
                WHEN LOWER(frontText) = LOWER(?) OR LOWER(backText) = LOWER(?) THEN 1
                WHEN LOWER(frontText) LIKE LOWER(? || '%') OR LOWER(backText) LIKE LOWER(? || '%') THEN 2
                WHEN LOWER(frontText) LIKE LOWER('%' || ? || '%') OR LOWER(backText) LIKE LOWER('%' || ? || '%') THEN 3
                ELSE 4 END AS relevance
            FROM \(DatabaseModelWord.databaseTableName)
        """
        
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
    
    // MARK: - Lifecycle
    init(dbQueue: DatabaseQueue) {
        self.dbQueue = dbQueue
    }
    
    // MARK: - Public Methods
    func fetch(
        search: String?,
        offset: Int,
        limit: Int
    ) throws -> [DatabaseModelWord] {
        guard limit > 0 else { throw DatabaseError.invalidLimit(limit) }
        guard offset >= 0 else { throw DatabaseError.invalidOffset(offset) }
        
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
                "[Word]: fetch with SQL \(sql) and arguments \(arguments)"
            )
            do {
                return try DatabaseModelWord.fetchAll(db, sql: sql, arguments: StatementArguments(arguments))
            } catch {
                throw DatabaseError.csvImportFailed("Failed to fetch words: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchCache(count: Int) throws -> [DatabaseModelWord] {
        guard count > 0 else { throw DatabaseError.invalidLimit(count) }
        
        let activeDictionaries = try fetchActive()
        guard !activeDictionaries.isEmpty else {
            throw DatabaseError.emptyActiveDictionaries
        }
        
        guard let selectedGroup = Dictionary(
            grouping: activeDictionaries, by: { $0.subcategory }
        ).randomElement() else {
            throw DatabaseError.csvImportFailed("No valid dictionary groups found")
        }
        
        let guids = selectedGroup.value.map { $0.guid }
        let placeholders = guids.map { _ in "?" }.joined(separator: ",")
        let sql = String(format: SQL.cacheSelect, placeholders)
        
        return try dbQueue.read { db in
            var arguments = guids as [DatabaseValueConvertible]
            arguments.append(count)
            
            do {
                return try DatabaseModelWord.fetchAll(db, sql: sql, arguments: StatementArguments(arguments))
            } catch {
                throw DatabaseError.csvImportFailed("Failed to fetch cache: \(error.localizedDescription)")
            }
        }
    }
    
    func save(_ word: DatabaseModelWord) throws {
        guard isValidWord(word) else {
            throw DatabaseError.invalidWord("Invalid word data provided")
        }
        
        try dbQueue.write { db in
            do {
                try formatWord(word).insert(db)
            } catch let error as DatabaseError {
                throw error
            } catch {
                throw DatabaseError.csvImportFailed("Failed to save word: \(error.localizedDescription)")
            }
        }
        Logger.debug(
            "[Word]: save - \(word)"
        )
    }
    
    func update(_ word: DatabaseModelWord) throws {
        guard isValidWord(word) else {
            throw DatabaseError.invalidWord("Invalid word data provided")
        }
        
        try dbQueue.write { db in
            do {
                try formatWord(word).update(db)
            } catch let error as DatabaseError {
                throw error
            } catch {
                throw DatabaseError.updateFailed(error.localizedDescription)
            }
        }
        Logger.debug(
            "[Word]: update - \(word)"
        )
    }
    
    func delete(_ word: DatabaseModelWord) throws {
        guard word.id != nil else {
            throw DatabaseError.invalidWord("Word has no ID")
        }
        
        try dbQueue.write { db in
            do {
                try word.delete(db)
            } catch {
                throw DatabaseError.deleteFailed(error.localizedDescription)
            }
        }
        Logger.debug(
            "[Word]: delete - \(word)"
        )
    }
    
    // MARK: - Private Methods
    private func fetchActive() throws -> [DatabaseModelDictionary] {
        try dbQueue.read { db in
            do {
                return try DatabaseModelDictionary.fetchAll(db, sql: SQL.fetchActive)
            } catch {
                throw DatabaseError.csvImportFailed("Failed to fetch active dictionaries: \(error.localizedDescription)")
            }
        }
    }
    
    private func formatWord(_ word: DatabaseModelWord) -> DatabaseModelWord {
        var formatted = word
        formatted.fmt()
        return formatted
    }
    
    private func isValidWord(_ word: DatabaseModelWord) -> Bool {
        !word.frontText.isEmpty &&
        !word.backText.isEmpty &&
        !word.dictionary.isEmpty
    }
    
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
