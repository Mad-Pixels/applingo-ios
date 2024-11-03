import Foundation

struct APIErrorMessage: Decodable {
    let message: String
}

struct DictionaryQueryRequest: Codable, Equatable {
    var id: String?
    var name: String?
    var category: String?
    var subcategory: String?
    var author: String?
    var isPrivate: Bool?
    var code: String?
    var lastEvaluated: String?
    var dictionaryKey: String?
    
    init(
        id: String? = nil,
        name: String? = nil,
        category: String? = nil,
        subcategory: String? = nil,
        author: String? = nil,
        isPrivate: Bool? = nil,
        code: String? = nil,
        lastEvaluated: String? = nil,
        dictionaryKey: String? = nil
    ) {
        self.id = id
        self.name = name
        self.category = category
        self.subcategory = subcategory
        self.author = author
        self.isPrivate = isPrivate
        self.code = code
        self.lastEvaluated = lastEvaluated
        self.dictionaryKey = dictionaryKey
    }
}

struct DictionaryQueryResponse: Decodable {
    let data: DictionaryQueryResponseBody
    let lastEvaluated: String?
}

struct DictionaryQueryResponseBody: Decodable {
    let items: [DictionaryItemModel]
}
