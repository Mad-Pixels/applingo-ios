import Foundation
import GRDB

/// Модель для представления информации о словаре.
struct DictionaryItem: Identifiable, Codable, Equatable, Hashable {
    /// Обязательные поля.
    var displayName: String
    var tableName: String
    var description: String
    var category: String
    var subcategory: String
    var author: String

    /// Предопределённые поля.
    var createdAt: Int
    var id: Int
    var isPrivate: Bool
    var isActive: Bool

    /// Инициализатор.
    init(
        displayName: String,
        tableName: String,
        description: String,
        category: String,
        subcategory: String,
        author: String,
        createdAt: Int = Int(Date().timeIntervalSince1970),
        id: Int = 0,
        isPrivate: Bool = true,
        isActive: Bool = true
    ) {
        self.displayName = displayName
        self.tableName = tableName
        self.description = description
        self.category = category
        self.subcategory = subcategory
        self.author = author
        self.createdAt = createdAt
        self.id = id
        self.isPrivate = isPrivate
        self.isActive = isActive
    }

    /// Дополнительные вычисляемые свойства.
    var subTitle: String {
        "[\(category)] \(subcategory)"
    }

    var formattedCreatedAt: String {
        let date = Date(timeIntervalSince1970: TimeInterval(createdAt))
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

extension DictionaryItem: FetchableRecord, PersistableRecord {
    static let databaseTableName = "Dictionary"

    static func createTable(in db: Database) throws {
        try db.create(table: databaseTableName, ifNotExists: true) { t in
            t.autoIncrementedPrimaryKey("id")
            t.column("displayName", .text).notNull()
            t.column("tableName", .text).notNull()
            t.column("description", .text).notNull()
            t.column("category", .text).notNull()
            t.column("subcategory", .text).notNull()
            t.column("author", .text).notNull()
            t.column("createdAt", .integer).notNull()
            t.column("isPrivate", .boolean).notNull()
            t.column("isActive", .boolean).notNull()
        }
        try db.create(index: "Dictionary_createdAt_idx", on: databaseTableName, columns: ["createdAt"])
    }

    static func updateStatus(in db: Database, dictionaryID: Int, newStatus: Bool) throws {
        let sql = "UPDATE \(databaseTableName) SET isActive = ? WHERE id = ?"
        try db.execute(sql: sql, arguments: [newStatus, dictionaryID])
    }

    mutating func insert(_ db: Database) throws {
        try db.execute(sql: """
            INSERT INTO \(DictionaryItem.databaseTableName)
            (displayName, tableName, description, category, subcategory, author, createdAt, isPrivate, isActive)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
            """, arguments: [
                displayName, tableName, description, category, subcategory, author, createdAt, isPrivate, isActive
            ])
    }
    


    static func fetchActiveDictionaries(in db: Database) throws -> [DictionaryItem] {
        return try DictionaryItem
            .filter(Column("isActive") == true)
            .fetchAll(db)
    }
}
