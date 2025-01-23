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
    var isActive: Bool
    var name: String
    
    init(
        uuid: String,
        name: String,
        author: String,
        category: String,
        subcategory: String,
        description: String,
        
        created: Int = Int(Date().timeIntervalSince1970),
        isActive: Bool = true,
        id: Int? = nil
    ) {
        self.subcategory = subcategory
        self.description = description
        self.isActive = isActive
        self.category = category
        self.author = author
        self.uuid = uuid
        self.name = name
        
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
        - Author: \(author)
        - Category: \(category)
        - Subcategory: \(subcategory)
        - Description: \(description)
        - Active: \(isActive ? "Yes" : "No")
        - Created: \(date)
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

extension DictionaryItemModel: FetchableRecord, PersistableRecord {
    static func createTable(in db: Database) throws {
        try db.create(table: databaseTableName, ifNotExists: true) { t in
            t.autoIncrementedPrimaryKey("id").unique()
            t.column("uuid", .text).unique()
            
            t.column("description", .text).notNull()
            t.column("subcategory", .text).notNull()
            t.column("category", .text).notNull()
            t.column("isActive", .boolean).notNull()
            t.column("created", .integer).notNull()
            t.column("author", .text).notNull()
            t.column("name", .text).notNull()
        }
        try db.create(index: "dictionary_created_idx", on: databaseTableName, columns: ["created"])
    }
}
