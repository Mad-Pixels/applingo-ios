import Foundation

/// Data model representing the dictionary-level metadata for table parsing.
public struct TableParserModelDictionary: Codable {
    public let guid: String
    public let name: String
    public let author: String
    public let category: String
    public let subcategory: String
    public let description: String
    
    public init(
        guid: String,
        name: String,
        author: String,
        category: String,
        subcategory: String,
        description: String
    ) {
        self.guid = guid
        self.name = name
        self.author = author
        self.category = category
        self.subcategory = subcategory
        self.description = description
    }
}
