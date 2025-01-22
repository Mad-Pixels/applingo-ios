import Foundation
import GRDB

struct DatabaseWord: Identifiable, Codable, Equatable {
    static let databaseTableName = "Words"
    
    internal let id: Int
    internal let created: Int
    
    var description: String
    var frontText: String
    var backText: String
    var hint: String
    
    var success: Int
    var weight: Int
    var fail: Int
    
    init(
        description: String,
        frontText: String,
        backText: String,
        hint: String,
        
        created: Int = Int(Date().timeIntervalSince1970),
        id: Int = -1
    ) {
        self.description = description
        self.frontText = frontText
        self.backText = backText
        self.hint = hint
        
        self.created = created
        self.id = id
        
        self.weight = 500
        self.success = 0
        self.fail = 0
        
        self.fmt()
    }
    
    var date: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        
        return formatter.string(
            from: Date(timeIntervalSince1970: TimeInterval(created))
        )
    }
    
    private mutating func fmt() {
        self.description = description.trimmedTrailingWhitespace
        self.frontText = frontText.trimmedTrailingWhitespace
        self.backText = frontText.trimmedTrailingWhitespace
        self.hint = hint.trimmedTrailingWhitespace
    }
}

extension DatabaseWord: FetchableRecord, PersistableRecord {
    static func createTable(in db: Database) throws {
        try db.create(table: databaseTableName, ifNotExists: true) { t in
            t.autoIncrementedPrimaryKey("id")
            t.column("frontText", .text).notNull()
            t.column("backText", .text).notNull()
            t.column("description", .text)
            t.column("hint", .text)
            t.column("created", .integer).notNull()
            t.column("success", .integer).notNull()
            t.column("weight", .integer).notNull()
            t.column("fail", .integer).notNull()
        }
        
        try db.create(index: "words_created_idx",
                     on: databaseTableName,
                     columns: ["created"])
    }
    
    func encode(to container: inout PersistenceContainer) throws {
        container["description"] = description
        container["frontText"] = frontText
        container["backText"] = backText
        container["created"] = created
        container["success"] = success
        container["weight"] = weight
        container["hint"] = hint
        container["fail"] = fail
    }
}
