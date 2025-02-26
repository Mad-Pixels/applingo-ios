import Foundation

/// Struct describing how table data is formatted (separator, header, quote/escape characters, etc.).
public struct ParserModelFormat {
    public let separator: String
    public let hasHeader: Bool
    public let quoteCharacter: Character
    public let escapeCharacter: Character
    
    public init(
        separator: String,
        hasHeader: Bool,
        quoteCharacter: Character,
        escapeCharacter: Character
    ) {
        self.separator = separator
        self.hasHeader = hasHeader
        self.quoteCharacter = quoteCharacter
        self.escapeCharacter = escapeCharacter
    }
    
    /// Standard CSV format.
    public static let csv = ParserModelFormat(
        separator: ",",
        hasHeader: true,
        quoteCharacter: "\"",
        escapeCharacter: "\\"
    )
    
    /// Standard TSV format.
    public static let tsv = ParserModelFormat(
        separator: "\t",
        hasHeader: true,
        quoteCharacter: "\"",
        escapeCharacter: "\\"
    )
    
    /// JSON format definition.
    public static let json = ParserModelFormat(
        separator: "",
        hasHeader: false,
        quoteCharacter: Character("\""),
        escapeCharacter: Character("\\")
    )
}
