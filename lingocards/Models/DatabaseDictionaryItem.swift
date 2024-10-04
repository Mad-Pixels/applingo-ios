import GRDB

struct DatabaseDictionaryItem: Codable, FetchableRecord, PersistableRecord {
    var id: Int64?
    var hashId: Int64
    var displayName: String
    var tableName: String
    var description: String
    var category: String
    var author: String
    var createdAt: Int64
    var isPrivate: Bool
    var isActive: Bool

    static let databaseTableName = "Dictionary"
}
