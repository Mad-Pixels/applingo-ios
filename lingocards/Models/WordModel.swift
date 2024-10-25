import Foundation
import GRDB

struct WordItem: Identifiable, Codable, Equatable {
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
        id: Int = 0,
        tableName: String,
        frontText: String,
        backText: String,
        description: String? = nil,
        hint: String? = nil,
        createdAt: Int = Int(Date().timeIntervalSince1970),
        success: Int = 0,
        weight: Int = 0,
        fail: Int = 0
    ) {
        self.id = id
        self.tableName = tableName
        self.frontText = frontText
        self.backText = backText
        self.description = description
        self.hint = hint
        self.createdAt = createdAt
        self.success = success
        self.weight = weight
        self.fail = fail
    }

    static func empty() -> WordItem {
        return WordItem(tableName: "", frontText: "", backText: "")
    }
}

extension WordItem: FetchableRecord, PersistableRecord {
    static let databaseTableName = "Words"

    static func createTable(in db: Database) throws {
        try db.create(table: databaseTableName, ifNotExists: true) { t in
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
        try db.create(index: "Words_tableName_idx", on: databaseTableName, columns: ["tableName"])
        try db.create(index: "Words_createdAt_idx", on: databaseTableName, columns: ["createdAt"])
    }

    mutating func insert(_ db: Database) throws {
        try db.execute(sql: """
            INSERT INTO \(WordItem.databaseTableName)
            (tableName, frontText, backText, description, hint, createdAt, success, weight, fail)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
            """, arguments: [
                tableName, frontText, backText, description ?? "", hint ?? "", createdAt, success, weight, fail
            ])
    }
}
