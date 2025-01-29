import Foundation

/// Data model representing the dictionary-level metadata for table parsing.
public struct TableParserModelDictionary: Codable {
    let guid: String
    let name: String
    let topic: String
    let author: String
    let category: String
    let subcategory: String
    let description: String
    let level: DictionaryLevelType
    
    init(
        guid: String,
        name: String,
        topic: String,
        author: String,
        category: String,
        subcategory: String,
        description: String,
        level: DictionaryLevelType
    ) {
        self.guid = guid
        self.name = name
        self.topic = topic
        self.author = author
        self.category = category
        self.subcategory = subcategory
        self.description = description
        self.level = level
    }
}
