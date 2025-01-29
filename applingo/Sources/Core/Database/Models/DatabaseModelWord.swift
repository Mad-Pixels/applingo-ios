import Foundation
import GRDB

/// Represents a word entity in the database, with fields for dictionary, text, metadata, and stats.
struct DatabaseModelWord: Identifiable, Codable, Equatable, Hashable {
    // MARK: - Constants
    static let databaseTableName = "words"

    // MARK: - Properties
    internal let id: Int?
    internal let uuid: String
    internal let created: Int
    
    var description: String
    var dictionary: String
    var frontText: String
    var backText: String
    var hint: String
    
    var success: Int
    var weight: Int
    var fail: Int

    // MARK: - Initialization
    init(
        dictionary: String,
        frontText: String,
        backText: String,
        
        weight: Int = 500,
        success: Int = 0,
        fail: Int = 0,
        
        description: String = "",
        hint: String = "",
        
        created: Int = Int(Date().timeIntervalSince1970),
        id: Int? = nil
    ) {
        self.description = description
        self.dictionary = dictionary
        self.frontText = frontText
        self.backText = backText
        
        self.success = success
        self.weight = weight
        self.fail = fail
        self.hint = hint
        
        self.uuid = UUID().uuidString
        self.created = created
        self.id = id
        
        self.fmt()
    }

    // MARK: - Methods
    
    /// Upsert method for skipping insert or update if wrod already exist (frontText, backText).
    func upsert(_ db: Database) throws {
        try db.execute(
            sql: """
            INSERT OR IGNORE INTO words
                (uuid, created, description, dictionary, frontText, backText, hint, success, weight, fail)
            VALUES
                (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            """,
            arguments: [
                uuid,
                created,
                description,
                dictionary,
                frontText,
                backText,
                hint,
                success,
                weight,
                fail
            ]
        )
    }

    /// Formats the word details to ensure consistency (e.g., trimming whitespace, converting to lowercase).
    mutating func fmt() {
        self.frontText = frontText.trimmedTrailingWhitespace.lowercased()
        self.backText = backText.trimmedTrailingWhitespace.lowercased()
        self.hint = hint.trimmedTrailingWhitespace.lowercased()
        self.description = description.trimmedTrailingWhitespace
    }

    /// Converts the word object into a readable string.
    func toString() -> String {
        """
        WordItemModel:
        - ID: \(id ?? -1)
        - UUID: \(uuid)
        - Dictionary: \(dictionary)
        - FrontText: \(frontText)
        - BackText: \(backText)
        - Description: \(description)
        - Hint: \(hint)
        - SuccessCount: \(success)
        - FailCount: \(fail)
        - Weight: \(weight)
        - Created: \(date)
        """
    }
    
    /// Provides a formatted date string for the word's creation timestamp.
    var date: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(
            from: Date(timeIntervalSince1970: TimeInterval(created))
        )
    }

    /// Returns a new empty word object.
    static func new() -> DatabaseModelWord {
        return DatabaseModelWord(
            dictionary: "",
            frontText: "",
            backText: ""
        )
    }
}

// MARK: - Database Record Conformance

extension DatabaseModelWord: FetchableRecord, PersistableRecord {
    /// Creates the `words` table in the database if it doesn't already exist.
    /// - Parameter db: The GRDB database instance.
    static func createTable(in db: Database) throws {
        try db.create(table: databaseTableName, ifNotExists: true) { t in
            t.autoIncrementedPrimaryKey("id").unique()
            t.column("uuid", .text).unique()
            
            t.column("description", .text).notNull()
            t.column("dictionary", .text).notNull()
            t.column("success", .integer).notNull()
            t.column("created", .integer).notNull()
            t.column("weight", .integer).notNull()
            t.column("frontText", .text).notNull()
            t.column("backText", .text).notNull()
            t.column("fail", .integer).notNull()
            t.column("hint", .text).notNull()
        }
        Logger.debug("[Database] Created words table structure")
        
        try db.create(
            index: "words_text_unique_idx",
            on: databaseTableName,
            columns: ["frontText", "backText"],
            unique: true
        )
        Logger.debug("[Database] Created unique index for frontText and backText")
        
        try db.create(
            index: "words_dictionary_idx",
            on: databaseTableName,
            columns: ["dictionary"]
        )
        Logger.debug("[Database] Created index on dictionary column")
        
        try db.create(
            index: "words_created_idx",
            on: databaseTableName,
            columns: ["created"]
        )
        Logger.debug("[Database] Created index on created column")
    }
}
