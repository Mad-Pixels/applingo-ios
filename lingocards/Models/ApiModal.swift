import Foundation

struct APIErrorMessage: Decodable {
    let message: String
}

struct DictionaryQueryRequest: Codable, Equatable {
    var id: String?
    var name: String?
    var category_main: String?
    var category_sub: String?
    var author: String?
    var is_public: Bool?
    var code: String?
    var last_evaluated: String?
    var limit: Int?
    var dictionary_key: String?
    
    init(
        id: String? = nil,
        name: String? = nil,
        category_main: String? = nil,
        category_sub: String? = nil,
        author: String? = nil,
        is_public: Bool? = nil,
        code: String? = nil,
        last_evaluated: String? = nil,
        limit: Int? = nil,
        dictionary_key: String? = nil
    ) {
        self.id = id
        self.name = name
        self.category_main = category_main
        self.category_sub = category_sub
        self.author = author
        self.is_public = is_public
        self.code = code
        self.last_evaluated = last_evaluated
        self.limit = limit
        self.dictionary_key = dictionary_key
    }
}

struct DictionaryQueryResponse: Decodable {
    let data: DictionaryQueryResponseBody
    let last_evaluated: String?
}

struct DictionaryQueryResponseBody: Decodable {
    let items: [DictionaryResponseItem]
}


struct DictionaryResponseItem: Decodable {
    let name: String
    let category_main: String
    let category_sub: String
    let author: String
    let dictionary_key: String
    let description: String
    
    // Метод для преобразования в DictionaryItem
    func toDictionaryItem() -> DictionaryItemModel {
        return DictionaryItemModel(
            displayName: name,
            tableName: dictionary_key,
            description: description,
            category: category_main,
            subcategory: category_sub,
            author: author
        )
    }
}
