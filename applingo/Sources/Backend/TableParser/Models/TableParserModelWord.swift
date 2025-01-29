import Foundation

/// Data model representing a single word/entry for table parsing.
public struct TableParserModelWord: Codable {
    public var dictionary: String
    public var frontText: String
    public var backText: String
    public var description: String
    public var hint: String
    
    public init(
        dictionary: String,
        frontText: String,
        backText: String,
        description: String,
        hint: String
    ) {
        self.dictionary = dictionary
        self.frontText = frontText
        self.backText = backText
        self.description = description
        self.hint = hint
    }
}
