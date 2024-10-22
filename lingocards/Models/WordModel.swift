import Foundation
import GRDB

/// Implemantation of row in Dictionary data table.
struct WordItem: Identifiable, Codable, Equatable {
    /// required fileds
    var tableName: String
    var frontText: String
    var backText: String
    
    /// optional fields
    var description: String?
    var hint: String?
    
    /// predefined fields
    var createdAt: Int
    var success: Int
    var weight: Int
    var fail: Int
    var id: Int
    
    /// UI id
    var uiID: String {
        return "\(id)_\(createdAt)_\(UUID().uuidString)"
    }

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
        
        self.frontText = Escape.text(frontText)
        self.backText = Escape.text(backText)
        self.description = description.map { Escape.text($0) } ?? ""
        self.hint = hint.map { Escape.text($0) } ?? ""
        
        self.success = success
        self.fail = fail
        self.weight = weight
        self.id = id
        
        self.createdAt = Int(Date().timeIntervalSince1970)
    }
    
    /// initialize empty object.
    static func empty() -> WordItem {
        return WordItem(
            tableName: "",
            frontText: "",
            backText: "",
            description: nil,
            hint: nil
        )
    }
}

extension WordItem: FetchableRecord, PersistableRecord {
    static func createTable(in db: Database, tableName: String) throws {
        try db.create(table: tableName) { t in
            t.autoIncrementedPrimaryKey("id")
            
            t.column("tableName", .text).notNull()
            t.column("frontText", .text).notNull()
            t.column("backText", .text).notNull()
            
            t.column("createdAt", .integer).notNull()
            t.column("success", .integer).notNull()
            t.column("weight", .integer).notNull()
            t.column("fail", .integer).notNull()
            
            t.column("description", .text)
            t.column("hint", .text)
        }
        
        try db.create(index: "\(tableName)_createdAt_idx", on: tableName, columns: ["createdAt"])
        try db.create(index: "\(tableName)_frontText_idx", on: tableName, columns: ["frontText"])
        try db.create(index: "\(tableName)_backText_idx", on: tableName, columns: ["backText"])
    }
    
    mutating func insert(_ db: Database) throws {
        try db.execute(sql: """
            INSERT INTO \(tableName) (tableName, frontText, backText, description, hint, createdAt, success, weight, fail)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
            """, arguments: [
                tableName, frontText, backText, description ?? "", hint ?? "", createdAt, success, weight, fail
            ])
    }
    
    static func deleteWord(
        in db: Database,
        fromTable tableName: String,
        wordID: Int
    ) throws {
        let sql = "DELETE FROM \(tableName) WHERE id = ?"
        try db.execute(sql: sql, arguments: [wordID])
    }
    
    static func updateWord(
        in db: Database,
        word: WordItem
    ) throws {
        try db.execute(sql: """
            UPDATE \(word.tableName) SET
            frontText = ?,
            backText = ?,
            description = ?,
            hint = ?,
            success = ?,
            fail = ?,
            weight = ?
            WHERE id = ?
            """, arguments: [
                word.frontText,
                word.backText,
                word.description ?? "",
                word.hint ?? "",
                word.success,
                word.fail,
                word.weight,
                word.id
            ])
    }
}
