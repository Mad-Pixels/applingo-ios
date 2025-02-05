import Foundation

/// A class responsible for handling dictionary import operations.
/// It parses a dictionary file from a local URL and saves the parsed data to the database.
/// This class can use optional dictionary metadata (provided by DictionaryDownload)
/// to correctly form the dictionary object.
final class DictionaryParser: ProcessDatabase {
    // MARK: - Initialization
    
    /// Initializes a new instance of `DictionaryParser`.
    /// The initializer logs the creation of the parser.
    override init() {
        super.init()
    }
    
    // MARK: - Public Methods
    
    /// Imports a dictionary from a given URL by parsing its contents and saving the results to the database.
    ///
    /// This method performs the following steps:
    /// 1. Initiates a database operation context.
    /// 2. Attempts to access the security-scoped resource at the URL.
    /// 3. Parses the file using a table parser to extract dictionary metadata and words.
    ///    If `dictionaryMetadata` is provided, it is used to correctly form the dictionary object.
    /// 4. Retrieves the shared database queue from `AppDatabase` and creates database managers.
    /// 5. Uses `TableParserManagerSave` to persist the parsed dictionary and words to the database.
    /// 6. Logs the completion of the save operation and notifies observers.
    ///
    /// - Parameters:
    ///   - url: The URL of the file to import.
    ///   - dictionaryMetadata: Optional metadata to construct the dictionary object properly.
    ///   - completion: A closure called with the result of the import operation.
    func importDictionary(from url: URL, dictionaryMetadata: TableParserModelDictionary? = nil, completion: @escaping (Result<Void, Error>) -> Void) {
        Logger.debug(
            "[Parser]: Starting dictionary import",
            metadata: ["url": url.absoluteString]
        )
        
        performDatabaseOperation(
            { [weak self] in
                guard let self = self else { return }
                
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
                        "[Parser]: Stopped accessing security scoped resource",
                        metadata: ["url": url.absoluteString]
                    )
                }
                
                let importManager = TableParserManagerImport()
                let (dictionaryModel, words) = try importManager.import(from: url, dictionaryMetadata: dictionaryMetadata)
                Logger.debug(
                    "[Parser]: File parsed successfully",
                    metadata: [
                        "dictionaryName": dictionaryModel.name,
                        "wordsCount": String(words.count)
                    ]
                )
                
                guard let dbQueue = AppDatabase.shared.databaseQueue else {
                    throw DatabaseError.connectionFailed(details: "Database connection is not established")
                }
                let dictionaryManager = DatabaseManagerDictionary(dbQueue: dbQueue)
                let wordManager = DatabaseManagerWord(dbQueue: dbQueue)
                
                try TableParserManagerSave(
                    processDatabase: self,
                    dictionaryManager: dictionaryManager,
                    wordManager: wordManager
                ).saveToDatabase(dictionary: dictionaryModel, words: words)
                Logger.debug(
                    "[Parser]: Dictionary saved to database",
                    metadata: [
                        "dictionaryName": dictionaryModel.name,
                        "wordsCount": String(words.count)
                    ]
                )
            },
            success: { _ in
                Logger.debug("[Parser]: Notifying about successful import")
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
