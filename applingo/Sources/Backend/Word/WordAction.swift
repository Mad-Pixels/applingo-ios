import Foundation
import Combine

/// A class responsible for performing CRUD operations on words in the database.
final class WordAction: ProcessDatabase {
    // MARK: - Private Properties
    
    private let dictionaryRepository: DatabaseManagerDictionary
    private let wordRepository: DatabaseManagerWord
    
    // MARK: - Initialization
    
    override init() {
        guard let dbQueue = AppDatabase.shared.databaseQueue else {
            fatalError("Database is not connected")
        }

        self.dictionaryRepository = DatabaseManagerDictionary(dbQueue: dbQueue)
        self.wordRepository = DatabaseManagerWord(dbQueue: dbQueue)
        super.init()
    }
    
    // MARK: - Public Methods

    /// Saves a new word to the database.
    /// - Parameters:
    ///   - word: The word to save.
    ///   - completion: Closure called with the result of the operation.
    func save(_ word: DatabaseModelWord, completion: @escaping (Result<Void, Error>) -> Void) {
        performOperation(
            { try self.wordRepository.save(word) },
            operation: "save",
            word: word,
            completion: completion
        )
    }

    /// Updates an existing word in the database.
    /// - Parameters:
    ///   - word: The word to update.
    ///   - completion: Closure called with the result of the operation.
    func update(_ word: DatabaseModelWord, completion: @escaping (Result<Void, Error>) -> Void) {
        performOperation(
            { try self.wordRepository.update(word) },
            operation: "update",
            word: word,
            completion: completion
        )
    }

    /// Deletes a word from the database.
    /// - Parameters:
    ///   - word: The word to delete.
    ///   - completion: Closure called with the result of the operation.
    func delete(_ word: DatabaseModelWord, completion: @escaping (Result<Void, Error>) -> Void) {
        performOperation(
            { try self.wordRepository.delete(word) },
            operation: "delete",
            word: word,
            completion: completion
        )
    }

    /// Fetches the display name of the dictionary containing the word.
    /// - Parameter word: The word whose dictionary name to fetch.
    /// - Returns: The display name of the dictionary or an empty string if not found.
    func dictionary(_ word: DatabaseModelWord) -> String {
        do {
            Logger.debug(
                "[Word]: Fetching dictionary",
                metadata: [
                    "dictionary": word.dictionary
                ]
            )
            return try dictionaryRepository.fetchName(byGuid: word.dictionary)
        } catch {
            handleError(
                error,
                screen: screen,
                metadata: createMetadata(operation: "fetchDictionaryDisplayName", word: word)
            )
            return ""
        }
    }
    
    // MARK: - Private Methods
    
    /// Performs a database operation with common metadata creation and error handling.
    private func performOperation(
        _ operation: @escaping () throws -> Void,
        operation name: String,
        word: DatabaseModelWord,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        Logger.debug(
            "[Word]: Performing operation",
            metadata: [
                "operation": name,
                "word": word.frontText
            ]
        )
        performDatabaseOperation(
            operation,
            success: { _ in },
            screen: screen,
            metadata: createMetadata(operation: name, word: word),
            completion: completion
        )
    }
    
    /// Creates metadata for word operations.
    private func createMetadata(operation: String, word: DatabaseModelWord) -> [String: String] {
        [
            "operation": operation,
            "word": word.toString()
        ]
    }
}
