import Foundation

/// A model representing the response for querying dictionaries via the API.
struct ApiModelDictionaryQueryResponse: Codable {
    /// The data container holding the response items and metadata.
    let data: ApiModelDictionaryDataContainer
}

/// A container for dictionary items and pagination metadata.
struct ApiModelDictionaryDataContainer: Codable {
    /// The list of dictionaries returned by the query.
    let items: [ApiModelDictionaryItem]
    
    /// The last evaluated key for paginated queries.
    let lastEvaluated: String?
    
    enum CodingKeys: String, CodingKey {
        case items
        case lastEvaluated = "last_evaluated"
    }
}
