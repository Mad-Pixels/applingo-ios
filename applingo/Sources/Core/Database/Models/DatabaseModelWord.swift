import Foundation
import GRDB

struct DatabaseModelWord: Identifiable, Codable, Equatable {
    static let databaseTableName = "words"
    
    internal let id: Int?
    internal let uuid: String
    internal let created: Int
    
    var description: String?
    var dictionary: String
    var frontText: String
    var backText: String
    var hint: String?
    
    var success: Int
    var weight: Int
    var fail: Int

    init(
        dictionary: String,
        frontText: String,
        backText: String,
        
        weight: Int = 500,
        success: Int = 0,
        fail: Int = 0,
        
        description: String? = nil,
        hint: String? = nil,
        
        created: Int = Int(Date().timeIntervalSince1970),
        id: Int? = nil
    ) {
        self.id = id
        self.dictionary = dictionary
        self.frontText = frontText
        self.backText = backText
        self.description = description
        self.hint = hint
        self.created = created
        self.success = success
        self.weight = weight
        self.fail = fail
        
        self.uuid = UUID().uuidString
        self.fmt()
    }
    
    static func empty() -> DatabaseModelWord {
        return DatabaseModelWord(
            dictionary: "",
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
        - Dictionary: \(dictionary)
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
            t.column("uuid", .text).unique()
            
            t.column("dictionary", .text).notNull()
            t.column("frontText", .text).notNull()
            t.column("backText", .text).notNull()
            t.column("description", .text)
            t.column("hint", .text)
            t.column("created", .integer).notNull()
            t.column("success", .integer).notNull()
            t.column("weight", .integer).notNull()
            t.column("fail", .integer).notNull()
        }
        try db.create(index: "words_dictionary_idx", on: databaseTableName, columns: ["dictionary"])
        try db.create(index: "words_created_idx", on: databaseTableName, columns: ["created"])
    }
}

extension DatabaseModelWord: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        
        if id == nil {
            hasher.combine(dictionary)
            hasher.combine(frontText)
            hasher.combine(backText)
            hasher.combine(created)
        }
    }
    
    static func == (lhs: DatabaseModelWord, rhs: DatabaseModelWord) -> Bool {
        if let lhsId = lhs.id, let rhsId = rhs.id {
            return lhsId == rhsId
        }
        
        return lhs.dictionary == rhs.dictionary &&
            lhs.frontText == rhs.frontText &&
            lhs.backText == rhs.backText &&
            lhs.created == rhs.created
    }
}
