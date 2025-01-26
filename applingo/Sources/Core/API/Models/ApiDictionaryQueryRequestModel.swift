import Foundation

struct ApiDictionaryQueryRequestModel: Codable, Equatable {
    var subcategory: String?
    var isPublic: Bool?  // var вместо let
    var sortBy: String?
    var lastEvaluated: String?  // var вместо let
    
    init(
        subcategory: String? = nil,
        isPublic: Bool? = nil,
        sortBy: ApiSortType? = nil,
        lastEvaluated: String? = nil
    ) {
        self.subcategory = subcategory
        self.isPublic = isPublic
        self.sortBy = sortBy?.rawValue
        self.lastEvaluated = lastEvaluated
    }
    
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [:]
        if let subcategory { dict["subcategory"] = subcategory }
        if let isPublic { dict["is_public"] = isPublic }
        if let sortBy { dict["sort_by"] = sortBy }
        if let lastEvaluated { dict["last_evaluated"] = lastEvaluated }
        return dict
    }
}
