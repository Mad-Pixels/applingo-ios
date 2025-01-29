import Foundation


final class DictionaryImporter {
    static let shared = DictionaryImporter()
    
    private init() {}
    
    func imports(
            from url: URL,
            dictionaryMetadata: DatabaseModelDictionary? = nil
        ) throws -> (dictionary: DatabaseModelDictionary, words: [DatabaseModelWord]) {
            Logger.debug("[DictionaryImporter] Importing file: \(url.lastPathComponent)")
            
            let parser = try DictionaryParserFactory.shared.parser(for: url)
            Logger.debug("[DictionaryImporter] Using parser: \(type(of: parser))")
            
            let words = try parser.parse(url: url, encoding: .utf8)
            Logger.debug("[DictionaryImporter] Parsed \(words.count) words")
            
            let dictionary = createDictionary(
                from: dictionaryMetadata,
                url: url
            )
            Logger.debug("[DictionaryImporter] Created dictionary: \(dictionary.guid)")
            
            return (dictionary, words)
        }
    
    private func createDictionary(
        from metadata: DatabaseModelDictionary?,
        url: URL
    ) -> DatabaseModelDictionary {
        if let metadata = metadata {
            return DatabaseModelDictionary(
                guid: metadata.guid,
                name: metadata.name,
                author: metadata.author,
                category: metadata.category,
                subcategory: metadata.subcategory,
                description: metadata.description
            )
        }
        
        return DatabaseModelDictionary(
            guid: url.lastPathComponent,
            name: url.deletingPathExtension().lastPathComponent,
            author: "local user",
            category: "Local",
            subcategory: "personal",
            description: "Imported from local file: '\(url.lastPathComponent)'"
        )
    }
}
