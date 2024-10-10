import Foundation

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
}
