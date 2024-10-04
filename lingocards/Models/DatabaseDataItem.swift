import GRDB

struct DataItem: Codable, FetchableRecord, PersistableRecord {
    var id: Int64?
    var hashId: Int64
    var frontText: String
    var backText: String
    var description: String?
    var hint: String?
    var createdAt: Int64
    var salt: Int64
    var success: Int64
    var fail: Int64
    var weight: Int64
    var tableName: String

    // Метод для получения имени таблицы
    static func databaseTableName(forDictionaryTableName tableName: String) -> String {
        return tableName
    }
}
