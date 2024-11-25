import Foundation

struct ApiErrorMessageModel: Decodable {
    let message: String
}

struct ApiDictionaryQueryRequestModel: Codable, Equatable {
    var subcategory: String?
    var isPublic: Bool?
    var sortBy: String?
    var lastEvaluated: String?
    
    enum SortBy: String {
        case date = "date"
        case rating = "rating"
    }
    
    init(
        subcategory: String? = nil,
        isPublic: Bool? = nil,
        sortBy: SortBy? = nil,
        lastEvaluated: String? = nil
    ) {
        self.subcategory = subcategory
        self.isPublic = isPublic
        self.sortBy = sortBy?.rawValue
        self.lastEvaluated = lastEvaluated
    }
    
    enum CodingKeys: String, CodingKey {
        case subcategory
        case isPublic = "is_public"
        case sortBy = "sort_by"
        case lastEvaluated = "last_evaluated"
    }
    
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [:]
        
        if let subcategory = subcategory {
            dict["subcategory"] = subcategory
        }
        if let isPublic = isPublic {
            dict["is_public"] = isPublic
        }
        if let sortBy = sortBy {
            dict["sort_by"] = sortBy
        }
        if let lastEvaluated = lastEvaluated {
            dict["last_evaluated"] = lastEvaluated
        }
        return dict
    }
}

extension ApiDictionaryQueryRequestModel.SortBy {
    var displayName: String {
        switch self {
        case .date:
            return LanguageManager.shared.localizedString(for: "DateCreated")
        case .rating:
            return LanguageManager.shared.localizedString(for: "Rating")
        }
    }
    
    static var allCases: [ApiDictionaryQueryRequestModel.SortBy] {
        [.date, .rating]
    }
}

struct ApiDictionaryDownloadRequestModel: Codable, Equatable {
    let dictionary: String
    let opertaion: String = "download"
    
    enum CodingKeys: String, CodingKey {
        case dictionary
    }
    
    func toDictionary() -> [String: Any] {
        return ["name": dictionary, "operation": "download"]
    }
}

struct ApiCategoryGetResponseModel: Codable {
    let data: CategoryItemModel
}

struct ApiDictionaryQueryResponseModel: Codable {
    let data: DataContainer
    
    struct DataContainer: Codable {
        let items: [DictionaryResponseItemModel]
        let lastEvaluated: String?
        
        enum CodingKeys: String, CodingKey {
            case items
            case lastEvaluated = "last_evaluated"
        }
    }
    
    struct DictionaryResponseItemModel: Codable {
        let name: String
        let category: String
        let subcategory: String
        let author: String
        let dictionary: String
        let description: String
        let createdAt: Int
        let rating: Int
        let isPublic: Int
        
        enum CodingKeys: String, CodingKey {
            case description
            case subcategory
            case dictionary
            case category
            case author
            case rating
            case name
            case createdAt = "created_at"
            case isPublic = "is_public"
            
        }
    }
}

struct ApiDictionaryDownloadResponseModel: Codable {
    let data: DownloadData
    
    struct DownloadData: Codable {
        let url: String
    }
}
