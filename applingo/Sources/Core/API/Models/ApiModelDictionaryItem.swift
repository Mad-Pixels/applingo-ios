import Foundation

/// A model representing an individual dictionary item in the response.
struct ApiModelDictionaryItem: Codable {
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
    
    /// The dictionary language level
    let level: String
    
    /// The dictionary topic
    let topic: String
    
    /// The dictionary words count
    let words: Int
    
    enum CodingKeys: String, CodingKey {
        case name, category, subcategory, author, dictionary, description, rating, level, topic, words
        case createdAt = "created"
        case isPublic = "public"
    }
}
