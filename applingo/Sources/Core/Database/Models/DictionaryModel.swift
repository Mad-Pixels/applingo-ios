import Foundation
import GRDB

struct DictionaryItemModel: Identifiable, Codable, Equatable, Hashable {
    static let databaseTableName = "dictionary"
    
    internal let id: Int?
    internal let uuid: String
    internal let created: Int
    
    var description: String
    var subcategory: String
    var category: String
    var author: String
    var name: String
    
    var isActive: Bool 
    
    init(
        uuid: String,
        name: String,
        description: String,
        category: String,
        subcategory: String,
        author: String,
        isActive: Bool = true,
        
        created: Int = Int(Date().timeIntervalSince1970),
        id: Int? = nil
    ) {
        self.uuid = uuid
        self.name = name
        self.description = description
        self.category = category
        self.subcategory = subcategory
        self.author = author
        
        self.isActive = isActive
        
        self.created = created
        self.id = id
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
    
    func toString() -> String {
        """
        DictionaryItemModel:
        - ID: \(id ?? -1)
        - UUID: \(uuid)
        - Name: \(name)
        - Description: \(description)
        - Category: \(category)
        - Subcategory: \(subcategory)
        - Author: \(author)
        - Created: \(date)
        - Active: \(isActive ? "Yes" : "No")
        """
    }
    
    mutating func fmt() {
        self.description = description.trimmedTrailingWhitespace
        self.subcategory = subcategory.trimmedTrailingWhitespace
        self.category = category.trimmedTrailingWhitespace
        self.author = author.trimmedTrailingWhitespace
        self.name = name.trimmedTrailingWhitespace
    }
}

extension DictionaryItemModel: FetchableRecord, PersistableRecord {
    static func createTable(in db: Database) throws {
        try db.create(table: databaseTableName, ifNotExists: true) { t in
            t.autoIncrementedPrimaryKey("id").unique()
            t.column("name", .text).notNull()
            t.column("description", .text).notNull()
            t.column("category", .text).notNull()
            t.column("subcategory", .text).notNull()
            t.column("author", .text).notNull()
            t.column("created", .integer).notNull()
            t.column("isActive", .boolean).notNull()
            t.column("uuid", .text).unique()
        }
        try db.create(index: "Dictionary_created_idx", on: databaseTableName, columns: ["created"])
    }
}

extension DictionaryItemModel {
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
