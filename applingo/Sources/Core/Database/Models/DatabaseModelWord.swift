import Foundation
import GRDB

struct DatabaseModelWord: Identifiable, Codable, Equatable {
    static let databaseTableName = "words"
    
    internal let id: Int?
    internal let created: Int
    
    var tableName: String
    var frontText: String
    var backText: String
    var description: String?
    var hint: String?
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
        created: Int = Int(Date().timeIntervalSince1970),
        success: Int = 0,
        weight: Int = 500,
        fail: Int = 0
    ) {
        self.id = id
        self.tableName = tableName
        self.frontText = frontText
        self.backText = backText
        self.description = description
        self.hint = hint
        self.created = created
        self.success = success
        self.weight = weight
        self.fail = fail
        
        self.fmt()
    }
    
    static func empty() -> DatabaseModelWord {
        return DatabaseModelWord(
            tableName: "",
            frontText: "",
            backText: ""
        )
    }
    
    var date: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(
            from: Date(timeIntervalSince1970: TimeInterval(created))
        )
    }
    
    func toString() -> String {
        """
        WordItemModel:
        - ID: \(id ?? -1)
        - Table Name: \(tableName)
        - Front Text: \(frontText)
        - Back Text: \(backText)
        - Description: \(description ?? "None")
        - Hint: \(hint ?? "None")
        - Success Count: \(success)
        - Weight: \(weight)
        - Fail Count: \(fail)
        - Created: \(date)
        """
    }
    
    mutating func fmt() {
        self.frontText = frontText.trimmedTrailingWhitespace.lowercased()
        self.backText = backText.trimmedTrailingWhitespace.lowercased()
        self.hint = hint?.trimmedTrailingWhitespace.lowercased()
        
        self.description = description?.trimmedTrailingWhitespace
    }
}

extension DatabaseModelWord: FetchableRecord, PersistableRecord {
    static func createTable(in db: Database) throws {
        try db.create(table: databaseTableName, ifNotExists: true) { t in
            t.autoIncrementedPrimaryKey("id").unique()
            t.column("tableName", .text).notNull()
            t.column("frontText", .text).notNull()
            t.column("backText", .text).notNull()
            t.column("description", .text)
            t.column("hint", .text)
            t.column("created", .integer).notNull()
            t.column("success", .integer).notNull()
            t.column("weight", .integer).notNull()
            t.column("fail", .integer).notNull()
        }
        try db.create(index: "Words_tableName_idx", on: databaseTableName, columns: ["tableName"])
        try db.create(index: "Words_createdAt_idx", on: databaseTableName, columns: ["createdAt"])
    }
}

extension DatabaseModelWord: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        
        if id == nil {
            hasher.combine(tableName)
            hasher.combine(frontText)
            hasher.combine(backText)
            hasher.combine(created)
        }
    }
    
    static func == (lhs: DatabaseModelWord, rhs: DatabaseModelWord) -> Bool {
        if let lhsId = lhs.id, let rhsId = rhs.id {
            return lhsId == rhsId
        }
        
        return lhs.tableName == rhs.tableName &&
            lhs.frontText == rhs.frontText &&
            lhs.backText == rhs.backText &&
            lhs.created == rhs.created
    }
}
