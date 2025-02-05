import Foundation

/// Abstract protocol describing a table parser capable of parsing a specific file type.
public protocol AbstractParser {
    /// Checks if this parser can handle a file with the given extension.
    /// - Parameter fileExtension: The file's extension.
    /// - Returns: `true` if it can parse this file type, otherwise `false`.
    func canHandle(fileExtension: String) -> Bool
    
    /// Parses the contents of a file from the specified URL.
    /// - Parameters:
    ///   - url: The URL of the file to parse.
    ///   - encoding: The character encoding to use when reading the file.
    /// - Returns: An array of `ParserModelWord` parsed from the file.
    /// - Throws: `ParserError` if parsing fails or the file is invalid.
    func parse(
        url: URL,
        encoding: String.Encoding
    ) throws -> [ParserModelWord]
}
