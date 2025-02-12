import Foundation
import GRDB
import Combine

/// A class responsible for handling dictionary import operations.
/// It parses a dictionary file from a local URL and saves the parsed data to the database.
/// This class can use optional dictionary metadata (provided by DictionaryDownload)
/// to correctly form the dictionary object.
final class DictionaryParser: ProcessDatabase {
    
    // MARK: - Constants
    
    private enum Constants {
        static let temporaryFilePrefix = "file:///private/var/mobile/Containers/Data/Application"
    }
    
    // MARK: - Properties
    
    private let transactionManager: DatabaseManagerTransaction
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    
    /// Initializes a new instance of `DictionaryParser`.
    /// - Note: Initializes required database managers and logs the creation.
    /// - Warning: Will fatally fail if database connection is not established.
    init() {
        guard let dbQueue = AppDatabase.shared.databaseQueue else {
            fatalError("Database connection is not established")
        }
        let dictionaryManager = DatabaseManagerDictionary(dbQueue: dbQueue)
        let wordManager = DatabaseManagerWord(dbQueue: dbQueue)
        self.transactionManager = DatabaseManagerTransaction(
            dictionaryManager: dictionaryManager,
            wordManager: wordManager
        )
        super.init(dbQueue: dbQueue)
    }
    
    // MARK: - Public Methods
    
    /// Imports a dictionary from a given URL by parsing its contents and saving the results to the database.
    ///
    /// This method performs the following steps:
    /// 1. Executes the parsing (which does not change the database) in a background context.
    /// 2. Attempts to access the security-scoped resource at the URL.
    /// 3. Parses the file using a table parser to extract dictionary metadata and words.
    ///    If `dictionaryMetadata` is provided, it is used to correctly form the dictionary object.
    /// 4. Upon successful parsing, executes a database transaction to save the dictionary and its words.
    /// 5. Logs the completion and notifies observers of the successful import.
    ///
    /// - Parameters:
    ///   - url: The URL of the file to import.
    ///   - dictionaryMetadata: Optional metadata to construct the dictionary object properly.
    ///   - completion: A closure called with the result of the import operation.
    func importDictionary(
        from url: URL,
        dictionaryMetadata: ParserModelDictionary? = nil,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        Logger.debug(
            "[Parser]: Starting dictionary import",
            metadata: ["url": url.absoluteString]
        )
        
        // Step 1: Parsing operation executed in a background context.
        performDatabaseOperation({ [weak self] () throws -> (ParserModelDictionary, [ParserModelWord]) in
            guard self != nil else {
                throw NSError(
                    domain: "DictionaryParser",
                    code: 0,
                    userInfo: [NSLocalizedDescriptionKey: "Self is nil"]
                )
            }
            
            guard FileManager.default.fileExists(atPath: url.path) else {
                throw URLError(.fileDoesNotExist)
            }
            
            let isTemporaryFile = url.absoluteString.hasPrefix(Constants.temporaryFilePrefix)
            
            if !isTemporaryFile {
                guard url.startAccessingSecurityScopedResource() else {
                    throw URLError(.noPermissionsToReadFile)
                }
                // Stop accessing security scoped resource immediately as in the original code.
                do {
                    url.stopAccessingSecurityScopedResource()
                    Logger.debug(
                        "[Parser]: Stopped accessing security scoped resource",
                        metadata: ["url": url.absoluteString]
                    )
                }
            }
            
            let importManager = ParserManagerImport()
            let (dictionaryModel, words) = try importManager.import(
                from: url,
                dictionaryMetadata: dictionaryMetadata
            )
            Logger.debug(
                "[Parser]: File parsed successfully",
                metadata: [
                    "dictionaryName": dictionaryModel.name,
                    "wordsCount": String(words.count)
                ]
            )
            return (dictionaryModel, words)
        }, screen: screen, metadata: [
            "operation": "importDictionary",
            "url": url.absoluteString
        ])
        // Step 2: Upon successful parsing, perform a database transaction to save the parsed data.
        .flatMap { [weak self] parseResult -> AnyPublisher<Void, Error> in
            guard let self = self else {
                return Fail(error: NSError(
                    domain: "DictionaryParser",
                    code: 0,
                    userInfo: [NSLocalizedDescriptionKey: "Self is nil"]
                )).eraseToAnyPublisher()
            }
            let (dictionaryModel, words) = parseResult
            return self.performDatabaseTransactionOperation({ db in
                try ParserManagerSave(
                    processDatabase: self,
                    transactionManager: self.transactionManager
                ).saveToDatabase(dictionary: dictionaryModel, words: words, db: db)
            }, screen: self.screen, metadata: [
                "operation": "importDictionary",
                "url": url.absoluteString
            ])
            .handleEvents(receiveOutput: { _ in
                Logger.debug(
                    "[Parser]: Dictionary saved to database",
                    metadata: [
                        "dictionaryName": dictionaryModel.name,
                        "wordsCount": String(words.count)
                    ]
                )
                NotificationCenter.default.post(
                    name: .dictionaryListShouldUpdate,
                    object: nil
                )
            })
            .eraseToAnyPublisher()
        }
        // Step 3: Subscribe to the combined publisher and call the provided completion handler.
        .sink { sinkCompletion in
            switch sinkCompletion {
            case .failure(let error):
                completion(.failure(error))
            case .finished:
                break
            }
        } receiveValue: { _ in
            completion(.success(()))
        }
        .store(in: &cancellables)
    }
}
