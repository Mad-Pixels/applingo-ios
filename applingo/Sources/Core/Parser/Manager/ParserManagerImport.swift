import NaturalLanguage
import Foundation
import GRDB

/// A manager responsible for importing table data and creating a dictionary-like model.
public final class ParserManagerImport {
    
    private let factory: ParserFactory
    
    /// Initializes the manager with a specific `ParserFactory`.
    /// - Parameter factory: The factory used to find the appropriate parser.
    public init(factory: ParserFactory = ParserFactory()) {
        self.factory = factory
    }
    
    /// Imports the content of a file at the specified URL, producing a tuple of `(ParserModelDictionary, [ParserModelWord])`.
    ///
    /// This method performs the following steps:
    /// 1. Logs the start of the import process.
    /// 2. Obtains a suitable parser from the factory based on the file extension.
    /// 3. Parses the file to extract an array of `ParserModelWord`.
    /// 4. Creates a `ParserModelDictionary` either from the provided metadata or based on the file name.
    /// 5. Logs the creation of the dictionary object.
    ///
    /// - Parameters:
    ///   - url: The URL of the file to import.
    ///   - dictionaryMetadata: An optional pre-configured `ParserModelDictionary`.
    /// - Throws: `ParserError` if no suitable parser is found or parsing fails.
    /// - Returns: A tuple containing a `ParserModelDictionary` and an array of `ParserModelWord`.
    public func `import`(
        from url: URL,
        dictionaryMetadata: ParserModelDictionary? = nil
    ) throws -> (dictionary: ParserModelDictionary, words: [ParserModelWord]) {
        
        Logger.debug("[Parser]: Starting import", metadata: ["url": "\(url)"])
        
        let parser = try factory.parser(for: url)
        Logger.debug("[Parser]: Using parser", metadata: ["parser_type": "\(type(of: parser))"])
        
        let words = try parser.parse(url: url, encoding: .utf8)
        Logger.debug("[Parser]: Parsed words", metadata: ["words_count": "\(words.count)"])
        
        let dictionary = createDictionary(from: dictionaryMetadata, url: url, words: words)
        Logger.debug("[ParserManagerImport]: Created dictionary", metadata: ["dictionary_guid": dictionary.guid])
        
        return (dictionary, words)
    }
    
    /// Creates a `ParserModelDictionary` from the provided metadata, or if nil,
    /// constructs one using the file name.
    ///
    /// If no metadata is provided, this method also tries to determine the subcategory
    /// based on the languages of `frontText` and `backText` using `NSLinguisticTagger`.
    /// If detection fails, a unique UUID is used to ensure the subcategory is unique.
    ///
    /// - Parameters:
    ///   - metadata: Optional pre-configured `ParserModelDictionary`.
    ///   - url: The URL to extract name information from if metadata is nil.
    ///   - words: The parsed words, used to infer language if needed.
    /// - Returns: A new `ParserModelDictionary`.
    private func createDictionary(
        from metadata: ParserModelDictionary?,
        url: URL,
        words: [ParserModelWord]
    ) -> ParserModelDictionary {
        if let meta = metadata {
            return ParserModelDictionary(
                guid: meta.guid,
                name: meta.name,
                topic: meta.topic,
                author: meta.author,
                category: meta.category,
                subcategory: meta.subcategory,
                description: meta.description,
                level: meta.level,
                isLocal: meta.isLocal
            )
        }
        
        let baseName = url.deletingPathExtension().lastPathComponent
        let subcategory = determineSubcategory(from: words)
        
        return ParserModelDictionary(
            guid: url.lastPathComponent,
            name: baseName,
            topic: "local",
            author: "local",
            category: "local",
            subcategory: subcategory,
            description: "Imported from local file: '\(url.lastPathComponent)'",
            level: .undefined,
            isLocal: true
        )
    }

    /// Attempts to determine the subcategory by detecting the languages used in the front and back texts.
    /// Returns a string like `"en-ru"`, or a UUID string if detection fails.
    ///
    /// - Parameter words: The parsed word list.
    /// - Returns: A `String` suitable for use as a subcategory.
    private func determineSubcategory(from words: [ParserModelWord]) -> String {
        let frontSample = words.prefix(30).map(\.frontText).joined(separator: " ")
        let backSample = words.prefix(30).map(\.backText).joined(separator: " ")

        guard let frontLang = detectLanguage(for: frontSample),
              let backLang = detectLanguage(for: backSample) else {
            Logger.warning("[Parser]: Could not detect language, using UUID for subcategory")
            return UUID().uuidString
        }

        Logger.debug("[Parser]: Auto-detected subcategory", metadata: ["subcategory": "\(frontLang)-\(backLang)"])
        return "\(frontLang)-\(backLang)"
    }

    /// Uses `NSLinguisticTagger` to detect the dominant language of a given text.
    ///
    /// - Parameter text: The text to analyze.
    /// - Returns: The ISO 639-1 language code (e.g., "en", "ru"), or nil if undetectable.
    private func detectLanguage(for text: String) -> String? {
        guard !text.isEmpty else { return nil }
        let tagger = NSLinguisticTagger(tagSchemes: [.language], options: 0)
        tagger.string = text
        return tagger.dominantLanguage
    }
}
