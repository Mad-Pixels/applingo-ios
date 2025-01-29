import Foundation

/// A manager responsible for importing table data and creating a dictionary-like model.
public final class TableParserManagerImport {
    
    private let factory: TableParserFactory
    
    /// Initializes the manager with a specific `TableParserFactory`.
    /// - Parameter factory: The factory used to find the appropriate parser.
    public init(factory: TableParserFactory = TableParserFactory()) {
        self.factory = factory
    }
    
    /// Imports the content of a file at the specified URL, producing a tuple of `(TableParserModelDictionary, [TableParserModelWord])`.
    /// - Parameters:
    ///   - url: The URL of the file to import.
    ///   - dictionaryMetadata: An optional pre-configured dictionary metadata object.
    /// - Throws: `TableParserError` if no suitable parser is found or parsing fails.
    /// - Returns: A tuple containing a `TableParserModelDictionary` and an array of `TableParserModelWord`.
    public func `import`(
        from url: URL,
        dictionaryMetadata: TableParserModelDictionary? = nil
    ) throws -> (dictionary: TableParserModelDictionary, words: [TableParserModelWord]) {
        
        Logger.debug("[ParserManagerImport]: Starting import", metadata: [
            "url": "\(url)"
        ])
        
        let parser = try factory.parser(for: url)
        
        Logger.debug("[ParserManagerImport]: Using parser", metadata: [
            "parser_type": "\(type(of: parser))"
        ])
        
        let words = try parser.parse(url: url, encoding: .utf8)
        
        Logger.debug("[ParserManagerImport]: Parsed words", metadata: [
            "words_count": "\(words.count)"
        ])
        
        let dictionary = createDictionary(from: dictionaryMetadata, url: url)
        
        Logger.debug("[ParserManagerImport]: Created dictionary", metadata: [
            "dictionary_guid": dictionary.guid
        ])
        
        return (dictionary, words)
    }
    
    /// Creates a `TableParserModelDictionary` from metadata if provided, otherwise from the file name.
    /// - Parameters:
    ///   - metadata: Optional pre-configured `TableParserModelDictionary`.
    ///   - url: The URL to extract name information from if metadata is nil.
    /// - Returns: A new `TableParserModelDictionary`.
    private func createDictionary(
        from metadata: TableParserModelDictionary?,
        url: URL
    ) -> TableParserModelDictionary {
        if let meta = metadata {
            return TableParserModelDictionary(
                guid: meta.guid,
                name: meta.name,
                topic: meta.topic,
                author: meta.author,
                category: meta.category,
                subcategory: meta.subcategory,
                description: meta.description,
                level: meta.level
            )
        }
        
        let baseName = url.deletingPathExtension().lastPathComponent
        return TableParserModelDictionary(
            guid: url.lastPathComponent,
            name: baseName,
            topic: "local",
            author: "local",
            category: "local",
            subcategory: "personal",
            description: "Imported from local file: '\(url.lastPathComponent)'",
            level: .undefined
        )
    }
}
