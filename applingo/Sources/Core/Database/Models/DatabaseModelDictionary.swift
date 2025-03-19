import Foundation
import GRDB

/// Represents a dictionary entity in the database, with fields for metadata, author, and categorization.
struct DatabaseModelDictionary: Identifiable, Codable, Equatable, Hashable {
    static let databaseTableName = "dictionary"
    static let internalDictionaryName = "internal"

    internal let id: Int?
    internal let guid: String
    internal let count: Int
    internal let created: Int
    internal let search: String

    var level: DictionaryLevelType
    var description: String
    var subcategory: String
    var category: String
    var author: String
    var isActive: Bool
    var isLocal: Bool
    var topic: String
    var name: String

    /// Initializes a new instance of `DatabaseModelDictionary`.
    init(
        guid: String,
        
        name: String = "",
        topic: String = "",
        author: String = "",
        category: String = "",
        subcategory: String = "",
        description: String = "",
        level: DictionaryLevelType = .undefined,
        
        created: Int = Int(Date().timeIntervalSince1970),
        count: Int = 0,
        isActive: Bool = true,
        isLocal: Bool = true,
        id: Int? = nil
    ) {
        self.subcategory = subcategory
        self.description = description
        self.isActive = isActive
        self.category = category
        self.isLocal = isLocal
        self.author = author
        self.topic = topic
        self.level = level
        self.guid = guid
        self.name = name
        
        self.created = created
        self.count = count
        self.id = id
        
        self.search = [
            name,
            author,
            description
        ].map { $0.lowercased() }.joined(separator: " ")
        
        self.fmt()
    }

    /// Provides a formatted date string for the dictionary's creation timestamp.
    var date: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(
            from: Date(timeIntervalSince1970: TimeInterval(created))
        )
    }
    
    /// Converts the dictionary object into a readable string.
    func toString() -> String {
        """
        DictionaryItemModel:
        - ID: \(id ?? -1)
        - GUID: \(guid)
        - Name: \(name)
        - Author: \(author)
        - Category: \(category)
        - Subcategory: \(subcategory)
        - Topic: \(topic)
        - Description: \(description)
        - Level: \(level.rawValue)
        - Local: \(isLocal ? "Yes" : "No")
        - Active: \(isActive ? "Yes" : "No")
        - Created: \(date)
        - Count: \(count)
        """
    }
    
    /// Formats the dictionary details to ensure consistency (e.g., trimming whitespace).
    mutating func fmt() {
        self.subcategory = subcategory.trimmedTrailingWhitespace.lowercased()
        self.category = category.trimmedTrailingWhitespace.lowercased()
        self.topic = topic.trimmedTrailingWhitespace.lowercased()
        self.description = description.trimmedTrailingWhitespace
        self.author = author.trimmedTrailingWhitespace
        self.name = name.trimmedTrailingWhitespace
    }

    /// Returns a new empty dictionary object.
    static func new() -> DatabaseModelDictionary {
        return DatabaseModelDictionary(guid: "-1")
    }

    /// Returns a new default internal dictionary object.
    static func newInternal() -> DatabaseModelDictionary {
        return DatabaseModelDictionary(
            guid: internalDictionaryName,
            name: "Main",
            topic: "internal",
            author: "MadPixels",
            category: "AppLingo",
            subcategory: "internal",
            description: "AppLingo default dictionary",
            isLocal: true
        )
    }
}

// MARK: - Database Record Conformance
extension DatabaseModelDictionary: FetchableRecord, PersistableRecord {
    /// Creates the `dictionary` table in the database if it doesn't already exist.
    /// - Parameter db: The GRDB database instance.
    static func createTable(in db: Database) throws {
        try db.create(table: databaseTableName, ifNotExists: true) { t in
            t.autoIncrementedPrimaryKey("id").unique()
            t.column("guid", .text).unique()
            
            t.column("description", .text).notNull()
            t.column("subcategory", .text).notNull()
            t.column("isActive", .boolean).notNull()
            t.column("islocal", .boolean).notNull()
            t.column("created", .integer).notNull()
            t.column("count", .integer).notNull()
            t.column("category", .text).notNull()
            t.column("author", .text).notNull()
            t.column("search", .text).notNull()
            t.column("level", .text).notNull()
            t.column("topic", .text).notNull()
            t.column("name", .text).notNull()
        }
        Logger.debug("[Database] Created dictionary table structure")
        
        try db.create(
            index: "dictionary_category_idx",
            on: databaseTableName,
            columns: ["category", "subcategory"]
        )
        Logger.debug("[Database] Created index on category and subcategory columns")
        
        try db.create(
            index: "dictionary_created_idx",
            on: databaseTableName,
            columns: ["created"]
        )
        Logger.debug("[Database] Created index on created column")
        
        try db.create(
            index: "dictionary_active_idx",
            on: databaseTableName,
            columns: ["isActive"]
        )
        Logger.debug("[Database] Created index on isActive column")
        
        try db.create(
            index: "dictionary_level_idx",
            on: databaseTableName,
            columns: ["level"]
        )
        Logger.debug("[Database] Created index on level column")
        
        try db.create(
            index: "dictionary_search_idx",
            on: databaseTableName,
            columns: ["search"]
        )
        Logger.debug("[Database] Created index on search column")
    }
}
