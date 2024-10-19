import Foundation
import GRDB

/// Implemantation of row in Dictionary main table.
struct DictionaryItem: Identifiable, Codable, Equatable, Hashable {
    /// required fileds
    var displayName: String
    var tableName: String
    var description: String
    var category: String
    var subcategory: String
    var author: String
    
    /// predefined fields
    var createdAt: Int
    var id: Int
    var isPrivate: Bool
    var isActive: Bool
    
    init(
        displayName: String,
        tableName: String,
        description: String,
        category: String,
        subcategory: String,
        author: String,
        
        isPrivate: Bool = true,
        isActive: Bool = true,
        id: Int = 0
    ) {
        self.tableName = tableName
        
        self.displayName = Escape.word(displayName)
        self.description = Escape.text(description)
        self.author = Escape.word(author)
        self.subcategory = subcategory
        self.category = category
        
        self.createdAt = Int(Date().timeIntervalSince1970)
        self.isPrivate = isPrivate
        self.isActive = isActive
        self.id = id
    }
    
    /// custom UI title
    var subTitle: String {
        "[\(category)] \(subcategory)"
    }
    
    /// custom UI date format
    var formattedCreatedAt: String {
        let date = Date(timeIntervalSince1970: TimeInterval(createdAt))
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

extension DictionaryItem: FetchableRecord, PersistableRecord {
    static let databaseTableName = "Dictionary"
    
    static func createTable(in db: Database) throws {
        try db.create(table: DictionaryItem.databaseTableName, ifNotExists: true) { t in
            t.autoIncrementedPrimaryKey("id")
            
            t.column("displayName", .text).notNull()
            t.column("tableName", .text).notNull()
            t.column("description", .text).notNull()
            t.column("category", .text).notNull()
            t.column("subcategory", .text).notNull()
            t.column("author", .text).notNull()
            t.column("createdAt", .integer).notNull()
            
            t.column("isPrivate", .boolean).notNull()
            t.column("isActive", .boolean).notNull()
        }
    }
    
    mutating func insert(_ db: Database) throws {
        try db.execute(sql: """
            INSERT INTO \(DictionaryItem.databaseTableName) 
            (displayName, tableName, description, category, subcategory, author, createdAt, isPrivate, isActive)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
            """, arguments: [
                displayName, tableName, description, category, subcategory, author, createdAt, isPrivate, isActive
            ])
    }
}
