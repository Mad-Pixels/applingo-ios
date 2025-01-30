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
        Logger.info(
            "[Dictionary]: Starting dictionary import",
            metadata: ["url": url.absoluteString]
        )
        
        performDatabaseOperation(
            {
                guard url.startAccessingSecurityScopedResource() else {
                    Logger.error(
                        "[Dictionary]: Failed to access security scoped resource",
                        metadata: ["url": url.absoluteString]
                    )
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
                        metadata: ["url": url.absoluteString]
                    )
                }
                
                Logger.debug("[Dictionary]: Creating import manager")
                let importManager = TableParserManagerImport()
                
                Logger.debug("[Dictionary]: Starting file parsing")
                let (dictionaryModel, words) = try importManager.import(from: url)
                
                Logger.info(
                    "[Dictionary]: File parsed successfully",
                    metadata: [
                        "dictionaryName": dictionaryModel.name,
                        "wordsCount": String(words.count)
                    ]
                )
                
                Logger.debug("[Dictionary]: Starting database save")
                let saveManager = TableParserManagerSave(processDatabase: self)
                saveManager.saveToDatabase(dictionary: dictionaryModel, words: words)
                
                Logger.info(
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
                if case .failure(let error) = result {
                    Logger.error(
                        "[Dictionary]: Import failed",
                        metadata: [
                            "error": error.localizedDescription,
                            "url": url.absoluteString
                        ]
                    )
                }
                completion(result)
            }
        )
    }
}
