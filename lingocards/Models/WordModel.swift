import Foundation
import GRDB

struct WordItemModel: Identifiable, Codable, Equatable {
    static let databaseTableName = "Words"
    
    var id: Int?
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
        id: Int? = nil,
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
        
        self.fmt()
    }
    
    static func empty() -> WordItemModel {
        return WordItemModel(
            tableName: "",
            frontText: "",
            backText: ""
        )
    }
    
    mutating func fmt() {
        self.frontText = frontText.trimmedTrailingWhitespace.lowercased()
        self.backText = backText.trimmedTrailingWhitespace.lowercased()
        self.hint = hint?.trimmedTrailingWhitespace.lowercased()
        
        self.description = description?.trimmedTrailingWhitespace
    }
}

extension WordItemModel: FetchableRecord, PersistableRecord {
    static func createTable(in db: Database) throws {
        try db.create(table: databaseTableName, ifNotExists: true) { t in
            t.autoIncrementedPrimaryKey("id").unique()
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
}
