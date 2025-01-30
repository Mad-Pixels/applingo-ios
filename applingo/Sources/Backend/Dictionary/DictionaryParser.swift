import Foundation

/// A class responsible for handling dictionary import operations.
final class DictionaryParser: ProcessDatabase {
    // MARK: - Initialization
    
    override init() {
        super.init()
        Logger.info("[Dictionary]: Parser Initialized")
    }
    
    // MARK: - Public Methods
    
    /// Imports a dictionary from a given URL.
    /// - Parameters:
    ///   - url: The URL of the file to import.
    ///   - completion: Closure called after import completion.
    func importDictionary(from url: URL, completion: @escaping (Result<Void, Error>) -> Void) {
        Logger.debug(
            "[Dictionary]: Starting dictionary import",
            metadata: ["url": url.absoluteString]
        )
        
        performDatabaseOperation(
            {
                guard url.startAccessingSecurityScopedResource() else {
                    ErrorManager.shared.process(
                        URLError(.noPermissionsToReadFile),
                        screen: self.screen,
                        metadata: [
                            "operation": "importDictionary",
                            "url": url.absoluteString
                        ]
                    )
                    return
                }
                defer {
                    url.stopAccessingSecurityScopedResource()
                    Logger.debug(
                        "[Dictionary]: Stopped accessing security scoped resource",
                        metadata: [
                            "url": url.absoluteString
                        ]
                    )
                }
                
                let importManager = TableParserManagerImport()
                let (dictionaryModel, words) = try importManager.import(from: url)
                Logger.debug(
                    "[Dictionary]: File parsed successfully",
                    metadata: [
                        "dictionaryName": dictionaryModel.name,
                        "wordsCount": String(words.count)
                    ]
                )
                
                let saveManager = TableParserManagerSave(processDatabase: self)
                saveManager.saveToDatabase(dictionary: dictionaryModel, words: words)
                Logger.debug(
                    "[Dictionary]: Dictionary saved to database",
                    metadata: [
                        "dictionaryName": dictionaryModel.name,
                        "wordsCount": String(words.count)
                    ]
                )
            },
            success: { _ in
                Logger.debug("[Dictionary]: Notifying about successful import")
                NotificationCenter.default.post(name: .dictionaryListShouldUpdate, object: nil)
            },
            screen: screen,
            metadata: [
                "operation": "importDictionary",
                "url": url.absoluteString
            ],
            completion: { result in
                completion(result)
            }
        )
    }
}
