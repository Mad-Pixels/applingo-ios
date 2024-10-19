import Foundation
import GRDB

struct WordItem: Identifiable, Codable, Equatable, FetchableRecord, PersistableRecord {
    var id: Int
    
    var tableName: String
    var frontText: String
    var backText: String
    
    var description: String?
    var hint: String?
    
    var createdAt: Int
    var success: Int
    var weight: Int
    var fail: Int

    init(
        tableName: String,
        frontText: String,
        backText: String,
        description: String? = nil,
        hint: String? = nil,
        success: Int = 0,
        fail: Int = 0,
        weight: Int = 0,
        id: Int = 0
    ) {
        self.tableName = tableName
        self.frontText = frontText
        self.backText = backText
        self.description = description
        self.hint = hint
        self.success = success
        self.fail = fail
        self.weight = weight
        self.id = id
        self.createdAt = Int(Date().timeIntervalSince1970)
    }
    
    static func empty() -> WordItem {
        return WordItem(
            tableName: "",
            frontText: "",
            backText: "",
            description: nil,
            hint: nil
        )
    }
    
    // Метод для создания таблицы
    static func createTable(in db: Database, tableName: String) throws {
        try db.create(table: tableName) { t in
            t.autoIncrementedPrimaryKey("id")
            t.column("tableName", .text).notNull()
            t.column("frontText", .text).notNull()
            t.column("backText", .text).notNull()
            t.column("description", .text)
            t.column("hint", .text)
            t.column("createdAt", .integer).notNull()
            t.column("success", .integer).notNull()
            t.column("weight", .integer).notNull()
            t.column("fail", .integer).notNull()
        }
    }
    
    // Определяем, как будет происходить вставка
    mutating func insert(_ db: Database) throws {
        try db.execute(sql: """
            INSERT INTO \(tableName) (tableName, frontText, backText, description, hint, createdAt, success, weight, fail)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
            """, arguments: [
                tableName, frontText, backText, description ?? "", hint ?? "", createdAt, success, weight, fail
            ])
    }
}
