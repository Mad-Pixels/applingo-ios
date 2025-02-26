import Foundation

/// Data model representing the dictionary-level metadata for table parsing.
public struct ParserModelDictionary: Codable {
    let guid: String
    let name: String
    let topic: String
    let author: String
    let category: String
    let subcategory: String
    let description: String
    let level: DictionaryLevelType
    let isLocal: Bool
    
    init(
        guid: String,
        name: String,
        topic: String,
        author: String,
        category: String,
        subcategory: String,
        description: String,
        level: DictionaryLevelType,
        isLocal: Bool
    ) {
        self.guid = guid
        self.name = name
        self.topic = topic
        self.author = author
        self.isLocal = isLocal
        self.category = category
        self.subcategory = subcategory
        self.description = description
        self.level = level
    }
}
