import Foundation
import GRDB

struct DictionaryItem: Identifiable, Codable, Equatable, Hashable {
    var id: Int
    var hashId: Int
    
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
        id: Int,
        hashId: Int,
        displayName: String,
        tableName: String,
        description: String,
        category: String,
        subcategory: String,
        author: String,
        createdAt: Int,
        isPrivate: Bool,
        isActive: Bool
    ) {
        self.id = id
        self.hashId = hashId
        self.displayName = displayName
        self.tableName = tableName
        self.description = description
        self.category = category
        self.subcategory = subcategory
        self.author = author
        self.createdAt = createdAt
        self.isPrivate = isPrivate
        self.isActive = isActive
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
    
    static let databaseTableName = "Dictionary"
}

// Реализуем протоколы для чтения и записи
extension DictionaryItem: FetchableRecord, PersistableRecord {
    // Метод для декодирования данных из базы
    init(row: Row) {
        id = row["id"]
        hashId = row["hashId"]
        displayName = row["displayName"]
        tableName = row["tableName"]
        description = row["description"]
        category = row["category"]
        subcategory = row["subcategory"]
        author = row["author"]
        createdAt = row["createdAt"]
        isPrivate = row["isPrivate"]
        isActive = row["isActive"]
    }

    // Указываем какие колонки использовать для вставки в базу данных
    func encode(to container: inout PersistenceContainer) {
        container["id"] = id
        container["hashId"] = hashId
        container["displayName"] = displayName
        container["tableName"] = tableName
        container["description"] = description
        container["category"] = category
        container["subcategory"] = subcategory
        container["author"] = author
        container["createdAt"] = createdAt
        container["isPrivate"] = isPrivate
        container["isActive"] = isActive
    }
}
