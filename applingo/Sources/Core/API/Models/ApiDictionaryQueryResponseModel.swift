import Foundation

/// A model representing the response for querying dictionaries via the API.
struct ApiDictionaryQueryResponseModel: Codable {
    /// The data container holding the response items and metadata.
    let data: DataContainer
    
    // MARK: - DataContainer
    
    /// A container for dictionary items and pagination metadata.
    struct DataContainer: Codable {
        /// The list of dictionaries returned by the query.
        let items: [DictionaryResponseItemModel]
        
        /// The last evaluated key for paginated queries.
        let lastEvaluated: String?
        
        enum CodingKeys: String, CodingKey {
            case items
            case lastEvaluated = "last_evaluated"
        }
    }
    
    // MARK: - DictionaryResponseItemModel
    
    /// A model representing an individual dictionary item in the response.
    struct DictionaryResponseItemModel: Codable {
        /// The name of the dictionary.
        let name: String
        
        /// The category to which the dictionary belongs.
        let category: String
        
        /// The subcategory to which the dictionary belongs.
        let subcategory: String
        
        /// The author of the dictionary.
        let author: String
        
        /// The unique identifier for the dictionary.
        let dictionary: String
        
        /// A brief description of the dictionary.
        let description: String
        
        /// The creation timestamp of the dictionary.
        let createdAt: Int
        
        /// The rating of the dictionary.
        let rating: Int
        
        /// A flag indicating whether the dictionary is public.
        let isPublic: Bool
        
        enum CodingKeys: String, CodingKey {
            case name, category, subcategory, author, dictionary, description, rating
            case createdAt = "created"
            case isPublic = "public"
        }
    }
}
