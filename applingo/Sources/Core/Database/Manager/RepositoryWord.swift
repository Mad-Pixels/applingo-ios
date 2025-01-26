import GRDB

class RepositoryWord {
    private let dbQueue: DatabaseQueue
    
    init(dbQueue: DatabaseQueue) {
        self.dbQueue = dbQueue
    }
    
    func fetch(
        searchText: String?,
        offset: Int,
        limit: Int
    ) throws -> [DatabaseModelWord] {
        let searchText = searchText?.lowercased()
        let activeDictionaries = try fetchActive()
        guard !activeDictionaries.isEmpty else {
            return []
        }
        let activeDisplayNames = activeDictionaries.map { $0.guid } as [DatabaseValueConvertible]
        
        return try dbQueue.read { db -> [DatabaseModelWord] in
            var sql: String
            var allArguments: [DatabaseValueConvertible] = []
            var conditions: [String] = []
            
            if !activeDisplayNames.isEmpty {
                let placeholders = activeDisplayNames.map { _ in "?" }.joined(separator: ", ")
                conditions.append("dictionary IN (\(placeholders))")
                allArguments.append(contentsOf: activeDisplayNames)
            }
            
            let trimmedSearchText = searchText?.trimmingCharacters(in: .whitespacesAndNewlines)
            let hasSearchText = !(trimmedSearchText?.isEmpty ?? true)
            
            if hasSearchText, let searchText = trimmedSearchText {
                sql = """
                SELECT *, CASE
                    WHEN LOWER(frontText) = LOWER(?) OR LOWER(backText) = LOWER(?) THEN 1
                    WHEN LOWER(frontText) LIKE LOWER(? || '%') OR LOWER(backText) LIKE LOWER(? || '%') THEN 2
                    WHEN LOWER(frontText) LIKE LOWER('%' || ? || '%') OR LOWER(backText) LIKE LOWER('%' || ? || '%') THEN 3
                    ELSE 4 END AS relevance
                FROM \(DatabaseModelWord.databaseTableName)
                """
                
                let relevanceArguments: [DatabaseValueConvertible] = [
                    searchText, searchText,
                    searchText, searchText,
                    searchText, searchText
                ]
                allArguments = relevanceArguments + allArguments
                
                conditions.append("(LOWER(frontText) LIKE ? OR LOWER(backText) LIKE ?)")
                allArguments.append("%\(searchText.lowercased())%")
                allArguments.append("%\(searchText.lowercased())%")
            } else {
                sql = "SELECT * FROM \(DatabaseModelWord.databaseTableName)"
            }
            if !conditions.isEmpty {
                sql += " WHERE " + conditions.joined(separator: " AND ")
            }
            if hasSearchText {
                sql += " ORDER BY relevance ASC, id ASC"
            } else {
                sql += " ORDER BY id ASC"
            }
            sql += " LIMIT ? OFFSET ?"
            allArguments.append(limit)
            allArguments.append(offset)
            
            Logger.debug("[RepositoryWord]: fetch with SQL \(sql) and arguments \(allArguments)")
            
            let request = SQLRequest<DatabaseModelWord>(
                sql: sql,
                arguments: StatementArguments(allArguments)
            )
            return try request.fetchAll(db)
        }
    }
    
    func fetchCache(count: Int) throws -> [DatabaseModelWord] {
        let activeDictionaries = try fetchActive()
        guard !activeDictionaries.isEmpty else { return [] }
        
        let dictionariesByCategory = Dictionary(grouping: activeDictionaries) {
            $0.subcategory
        }
        print(dictionariesByCategory)
        // Берем случайную группу !!!!!
        guard let selectedGroup = dictionariesByCategory.randomElement() else {
            return []
        }
        let guids = selectedGroup.value.map { $0.guid }
        print(selectedGroup)
        print(guids)
        
        let sql = """
            WITH UniqueWords AS (
                SELECT *, ROW_NUMBER() OVER (PARTITION BY frontText, backText ORDER BY weight) as rn
                FROM \(DatabaseModelWord.databaseTableName)
                WHERE dictionary IN (\(guids.map { _ in "?" }.joined(separator: ",")))
            )
            SELECT * FROM UniqueWords 
            WHERE rn = 1
            ORDER BY (CASE WHEN RANDOM() < 0.6 THEN RANDOM() ELSE weight END)
            LIMIT ?
        """

        return try dbQueue.read { db in
            var arguments = guids as [DatabaseValueConvertible]
            arguments.append(count)
            return try DatabaseModelWord.fetchAll(db, sql: sql, arguments: StatementArguments(arguments))
        }
    }

    func save(_ word: DatabaseModelWord) throws {
        var fmtWord = word
        fmtWord.fmt()
        
        try dbQueue.write { db in
            try fmtWord.insert(db)
        }
        Logger.debug("[RepositoryWord]: save - \(word)")
    }
    
    func update(_ word: DatabaseModelWord) throws {
        var fmtWord = word
        fmtWord.fmt()
        
        try dbQueue.write { db in
            try fmtWord.update(db)
        }
        Logger.debug("[RepositoryWord]: update - \(word)")
    }
    
    func delete(_ word: DatabaseModelWord) throws {
        _ = try dbQueue.write { db in
            try word.delete(db)
        }
        Logger.debug("[RepositoryWord]: delete - \(word)")
    }
    
    private func fetchActive() throws -> [DatabaseModelDictionary] {
        let activeDictionaries = try dbQueue.read { db in
            let sql = "SELECT * FROM \(DatabaseModelDictionary.databaseTableName) WHERE isActive = 1"
            return try DatabaseModelDictionary.fetchAll(db, sql: sql)
        }
        guard !activeDictionaries.isEmpty else {
            return []
        }
        return activeDictionaries
    }
}
