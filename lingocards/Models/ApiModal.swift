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
    
    func toDictionary() -> [String: Any] {
            var dict: [String: Any] = [:]
            
            if let id = id {
                dict["id"] = id
            }
            if let name = name {
                dict["name"] = name
            }
            if let category = category {
                dict["category"] = category
            }
            if let subcategory = subcategory {
                dict["subcategory"] = subcategory
            }
            if let author = author {
                dict["author"] = author
            }
            if let isPrivate = isPrivate {
                dict["is_private"] = isPrivate
            }
            if let code = code {
                dict["code"] = code
            }
            if let lastEvaluated = lastEvaluated {
                dict["last_evaluated"] = lastEvaluated
            }
            if let dictionaryKey = dictionaryKey {
                dict["dictionary_key"] = dictionaryKey
            }
            
            return dict
        }
}

struct ApiCategoryResponseModel: Codable {
    let data: CategoryItemModel
}

struct ApiDictionaryResponseModel: Codable {
    let data: DataContainer
    
    struct DataContainer: Codable {
        let items: [DictionaryItem]
        let lastEvaluated: String?
        
        enum CodingKeys: String, CodingKey {
            case items
            case lastEvaluated = "last_evaluated"
        }
    }
    
    struct DictionaryItem: Codable {
        let name: String
        let categoryMain: String
        let categorySub: String
        let author: String
        let dictionaryKey: String
        let description: String
        
        enum CodingKeys: String, CodingKey {
            case name
            case categoryMain = "category_main"
            case categorySub = "category_sub"
            case author
            case dictionaryKey = "dictionary_key"
            case description
        }
    }
}
