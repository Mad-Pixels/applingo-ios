import Foundation
import CryptoKit
import GRDB

struct DatabaseDictionary: Identifiable, Codable, Equatable, Hashable {
    static let databaseTable = "dictionary"
    
    internal let id: Int
    internal let created: Int
    internal var uniq: String
    
    var description: String
    var subcategory: String
    var category: String
    var author: String
    var active: Bool
    var name: String
    
    init(
        name: String,
        author: String,
        category: String,
        subcategory: String,
        description: String,
        
        created: Int = Int(Date().timeIntervalSince1970),
        id: Int = -1
    ) {
        self.description = description
        self.subcategory = subcategory
        self.category = category
        self.author = author
        self.name = name
        
        self.created = created
        self.active = true
        self.id = id
        
        self.uniq = ""
        self.key()
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
    
    private mutating func key() {
        if let data = "\(name)-\(author)".data(using: .utf8) {
            let hashed = Insecure.MD5.hash(data: data)
            self.uniq = hashed.map { String(format: "%02hhx", $0) }.joined()
        }
    }
    
    private mutating func fmt() {
        self.description = description.trimmedTrailingWhitespace
        self.subcategory = subcategory.trimmedTrailingWhitespace
        self.category = category.trimmedTrailingWhitespace
        self.author = author.trimmedTrailingWhitespace
        self.name = name.trimmedTrailingWhitespace
    }
}

extension DatabaseDictionary {
    var searchableText: String {
        return [name, author, description]
            .map { $0.lowercased() }
            .joined(separator: " ")
    }
    
    func matches(searchText: String) -> Bool {
        if searchText.isEmpty { return true }
        return searchableText.contains(searchText.lowercased())
    }
}

extension DatabaseDictionary: FetchableRecord, PersistableRecord {
    static let databaseTableName = "dictionary"
    
    static func createTable(in db: Database) throws {
        try db.create(table: databaseTableName, ifNotExists: true) { t in
            t.autoIncrementedPrimaryKey("id")
            
            t.column("subcategory", .text).notNull()
            t.column("description", .text).notNull()
            t.column("created", .integer).notNull()
            t.column("active", .boolean).notNull()
            t.column("category", .text).notNull()
            t.column("author", .text).notNull()
            t.column("name", .text).notNull()
            t.column("uniq", .text).unique()
        }
        
        try db.create(index: "dictionary_created_idx",
                     on: databaseTableName,
                     columns: ["created"])
    }
    
    func encode(to container: inout PersistenceContainer) throws {
        container["subcategory"] = subcategory
        container["description"] = description
        container["category"] = category
        container["created"] = created
        container["author"] = author
        container["active"] = active
        container["name"] = name
        container["uniq"] = uniq
    }
}
