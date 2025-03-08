import Foundation

/// Data model representing a single word/entry for table parsing.
public struct ParserModelWord: Codable {
    public var dictionary: String
    public var frontText: String
    public var backText: String
    public var description: String
    public var hint: String
    
    enum CodingKeys: String, CodingKey {
        case frontText = "word"
        case backText = "translation"
        case description = "description"
        case hint = "hint"
        case dictionary
    }
    
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
