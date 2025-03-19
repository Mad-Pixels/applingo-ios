import Foundation
import Combine

/// A class responsible for performing CRUD operations on words in the database.
final class WordAction: ProcessDatabase {
    // MARK: - Private Properties
    
    private let dictionaryRepository: DatabaseManagerDictionary
    private let wordRepository: DatabaseManagerWord
    private let dictionaryAction: DictionaryAction
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    init() {
        guard let dbQueue = AppDatabase.shared.databaseQueue else {
            fatalError("Database is not connected")
        }
        
        self.dictionaryRepository = DatabaseManagerDictionary(dbQueue: dbQueue)
        self.wordRepository = DatabaseManagerWord(dbQueue: dbQueue)
        self.dictionaryAction = DictionaryAction()
        super.init(dbQueue: dbQueue)
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
            completion: { [weak self] result in
                guard let self = self else { return }
                
                if case .success = result {
                    self.updateDictionaryCount(dictionaryGuid: word.dictionary)
                }
                completion(result)
            }
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
        let dictionaryGuid = word.dictionary
        
        performOperation(
            { try self.wordRepository.delete(word) },
            operation: "delete",
            word: word,
            completion: { [weak self] result in
                guard let self = self else { return }
                    
                if case .success = result {
                    self.updateDictionaryCount(dictionaryGuid: dictionaryGuid)
                }
                completion(result)
            }
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
            screen: screen,
            metadata: createMetadata(operation: name, word: word)
        )
        .sink { [weak self] completionResult in
            guard let _ = self else { return }
            switch completionResult {
            case .failure(let error):
                completion(.failure(error))
            case .finished:
                break
            }
        } receiveValue: { [weak self] _ in
            guard let _ = self else { return }
            completion(.success(()))
        }
        .store(in: &cancellables)
    }
    
    /// Update dictionary words count.
    private func updateDictionaryCount(dictionaryGuid: String) {
        do {
            let count = try dictionaryRepository.count(forDictionary:
                            DatabaseModelDictionary(guid: dictionaryGuid))
            
            dictionaryAction.updateCount(guid: dictionaryGuid, newCount: count) { result in
                if case .failure(let error) = result {
                    Logger.error(
                        "[Word]: Failed to update dictionary count",
                        metadata: [
                            "dictionaryGuid": dictionaryGuid,
                            "error": error.localizedDescription
                        ]
                    )
                }
            }
        } catch {
            Logger.error(
                "[Word]: Failed to count words",
                metadata: [
                    "dictionaryGuid": dictionaryGuid,
                    "error": error.localizedDescription
                ]
            )
        }
    }
    
    /// Creates metadata for word operations.
    private func createMetadata(operation: String, word: DatabaseModelWord) -> [String: String] {
        [
            "operation": operation,
            "word": word.toString()
        ]
    }
}
