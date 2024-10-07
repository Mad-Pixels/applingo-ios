import Foundation

struct WordItem: Identifiable, Codable {
    var id: Int
    var hashId: Int
    
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
