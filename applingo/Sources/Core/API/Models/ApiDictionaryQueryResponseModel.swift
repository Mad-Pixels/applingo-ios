import Foundation

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
        let isPublic: Bool
        
        enum CodingKeys: String, CodingKey {
            case name, category, subcategory, author, dictionary, description, rating
            case createdAt = "created"
            case isPublic = "public"
        }
    }
}
