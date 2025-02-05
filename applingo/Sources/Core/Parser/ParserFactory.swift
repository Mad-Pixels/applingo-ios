import Foundation

/// Factory for creating a parser instance depending on the file extension.
public final class ParserFactory {
    
    private let parsers: [AbstractParser]
    
    /// Initializes the factory with a list of available parsers.
    /// - Parameter parsers: An array of parser instances.
    public init(parsers: [AbstractParser] = [
        ParseCSV(),
        ParseTSV()
    ]) {
        self.parsers = parsers
    }
    
    /// Returns a suitable parser for the given file URL based on its extension.
    /// - Parameter url: The file URL.
    /// - Throws: `ParserError.unsupportedFormat` if no suitable parser is found.
    /// - Returns: An instance of `AbstractParser` that can parse the file.
    public func parser(for url: URL) throws -> AbstractParser {
        let fileExtension = url.pathExtension
        
        Logger.debug("[Parser]: Looking for parser", metadata: [
            "file_name": "\(url.lastPathComponent)",
            "file_extension": "\(fileExtension)"
        ])
        
        guard let parser = parsers.first(where: { $0.canHandle(fileExtension: fileExtension) }) else {
            Logger.debug("[Parser]: No parser found for extension", metadata: [
                "extension": fileExtension
            ])
            throw ParserError.unsupportedFormat
        }
        
        return parser
    }
}
