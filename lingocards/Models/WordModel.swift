import Foundation
import GRDB

struct WordItem: Identifiable, Codable, Equatable, FetchableRecord, PersistableRecord {
    var id: Int
    var hashId: Int
    
    var tableName: String
    var frontText: String
    var backText: String
    
    var description: String?
    var hint: String?
    
    var createdAt: Int
    var success: Int
    var weight: Int
    var salt: Int
    var fail: Int

    init(
        id: Int,
        hashId: Int,
        tableName: String,
        frontText: String,
        backText: String,
        description: String? = nil,
        hint: String? = nil,
        createdAt: Int,
        salt: Int,
        success: Int = 0,
        fail: Int = 0,
        weight: Int = 0
    ) {
        self.id = id
        self.hashId = hashId
        self.tableName = tableName
        self.frontText = frontText
        self.backText = backText
        self.description = description
        self.hint = hint
        self.createdAt = createdAt
        self.salt = salt
        self.success = success
        self.fail = fail
        self.weight = weight
    }
    
    static func empty() -> WordItem {
        return WordItem(
            id: 0,
            hashId: 0,
            tableName: "",
            frontText: "",
            backText: "",
            description: nil,
            hint: nil,
            createdAt: 0,
            salt: 0
        )
    }
    
    // Метод для создания таблицы
    static func createTable(in db: Database, tableName: String) throws {
        try db.create(table: tableName) { t in
            t.autoIncrementedPrimaryKey("id")
            t.column("hashId", .integer).unique()
            t.column("tableName", .text).notNull()
            t.column("frontText", .text).notNull()
            t.column("backText", .text).notNull()
            t.column("description", .text)
            t.column("hint", .text)
            t.column("createdAt", .integer).notNull()
            t.column("success", .integer).notNull()
            t.column("weight", .integer).notNull()
            t.column("salt", .integer).notNull()
            t.column("fail", .integer).notNull()
        }
    }
    
    // Определяем, как будет происходить вставка
    mutating func insert(_ db: Database) throws {
        try db.execute(sql: """
            INSERT INTO \(tableName) (hashId, tableName, frontText, backText, description, hint, createdAt, success, weight, salt, fail)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            """, arguments: [
                hashId, tableName, frontText, backText, description ?? "", hint ?? "", createdAt, success, weight, salt, fail
            ])
    }
}
