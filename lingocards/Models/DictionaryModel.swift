import Foundation
import GRDB

struct DictionaryItemModel: Identifiable, Codable, Equatable, Hashable {
    static let databaseTableName = "Dictionary"
    
    var id: Int?
    var displayName: String
    var tableName: String
    var description: String
    var category: String
    var subcategory: String
    var author: String

    var createdAt: Int
    var isPrivate: Bool
    var isActive: Bool
    
    init(
        id: Int? = nil,
        displayName: String,
        tableName: String,
        description: String,
        category: String,
        subcategory: String,
        author: String,
        createdAt: Int = Int(Date().timeIntervalSince1970),
        isPrivate: Bool = true,
        isActive: Bool = true
    ) {
        self.id = id
        self.displayName = displayName
        self.tableName = tableName
        self.description = description
        self.category = category
        self.subcategory = subcategory
        self.author = author
        self.createdAt = createdAt
        self.isPrivate = isPrivate
        self.isActive = isActive
        
        self.fmt()
    }

    var subTitle: String {
        "[\(category)] \(subcategory)"
    }

    var formattedCreatedAt: String {
        let date = Date(timeIntervalSince1970: TimeInterval(createdAt))
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    mutating func fmt() {
        self.displayName = displayName.trimmedTrailingWhitespace
        self.description = description.trimmedTrailingWhitespace
        self.subcategory = subcategory.trimmedTrailingWhitespace
        self.category = category.trimmedTrailingWhitespace
        self.author = author.trimmedTrailingWhitespace
    }
}

extension DictionaryItemModel: FetchableRecord, PersistableRecord {
    static func createTable(in db: Database) throws {
        try db.create(table: databaseTableName, ifNotExists: true) { t in
            t.autoIncrementedPrimaryKey("id").unique()
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
        try db.create(index: "Dictionary_createdAt_idx", on: databaseTableName, columns: ["createdAt"])
    }
}
