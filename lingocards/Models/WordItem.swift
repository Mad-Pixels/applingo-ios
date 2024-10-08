import Foundation

struct WordItem: Identifiable, Codable, Equatable {
    var id: Int
    var hashId: Int
    
    var tableName: String
    var frontText: String
    var backText: String
    
    var description: String?
    var hint: String?
    
    var createdAt: Int
    var success: Int
    var weight: Int
    var salt: Int
    var fail: Int

    init(
        id: Int,
        hashId: Int,
        tableName: String,
        frontText: String,
        backText: String,
        description: String? = nil,
        hint: String? = nil,
        createdAt: Int,
        salt: Int,
        success: Int = 0,
        fail: Int = 0,
        weight: Int = 0
    ) {
        self.id = id
        self.hashId = hashId
        self.tableName = tableName
        self.frontText = frontText
        self.backText = backText
        self.description = description
        self.hint = hint
        self.createdAt = createdAt
        self.salt = salt
        self.success = success
        self.fail = fail
        self.weight = weight
    }
}
