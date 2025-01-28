import Foundation
import Combine
import GRDB

/// A class responsible for performing CRUD operations on dictionaries in the database.
///
/// `DictionaryAction` handles saving, updating, deleting, and status changes for dictionaries.
final class DictionaryAction: ProcessDatabase {
    // MARK: - Private Properties
    
    private let dictionaryRepository: DatabaseManagerDictionary
    private let screenType: ScreenType = .DictionaryLocalList
    private var screen: ScreenType = .Home
    
    // MARK: - Initialization
    
    override init() {
        guard let dbQueue = AppDatabase.shared.databaseQueue else {
            fatalError("Database is not connected")
        }
        self.dictionaryRepository = DatabaseManagerDictionary(dbQueue: dbQueue)
        super.init()
    }
    
    // MARK: - Public Methods
    
    /// Sets the current screen type for operation tracking.
    /// - Parameter screen: The screen type to set.
    func setFrame(_ screen: ScreenType) {
        Logger.debug("[Action]: Setting frame", metadata: ["frame": screen.rawValue])
        self.screen = screen
    }
    
    // MARK: - CRUD Operations
    
    /// Saves a new dictionary to the database.
    /// - Parameters:
    ///   - dictionary: The dictionary to save.
    ///   - completion: Closure called with the result of the operation.
    func save(_ dictionary: DatabaseModelDictionary, completion: @escaping (Result<Void, Error>) -> Void) {
        performOperation(
            { try self.dictionaryRepository.save(dictionary) },
            operation: "save",
            dictionary: dictionary,
            completion: completion
        )
    }
    
    /// Updates an existing dictionary in the database.
    /// - Parameters:
    ///   - dictionary: The dictionary to update.
    ///   - completion: Closure called with the result of the operation.
    func update(_ dictionary: DatabaseModelDictionary, completion: @escaping (Result<Void, Error>) -> Void) {
        performOperation(
            { try self.dictionaryRepository.update(dictionary) },
            operation: "update",
            dictionary: dictionary,
            completion: completion
        )
    }
    
    /// Deletes a dictionary from the database.
    /// - Parameters:
    ///   - dictionary: The dictionary to delete.
    ///   - completion: Closure called with the result of the operation.
    func delete(_ dictionary: DatabaseModelDictionary, completion: @escaping (Result<Void, Error>) -> Void) {
        performOperation(
            { try self.dictionaryRepository.delete(dictionary) },
            operation: "delete",
            dictionary: dictionary,
            completion: completion
        )
    }
    
    /// Updates the active status of a dictionary.
    /// - Parameters:
    ///   - dictionaryID: The ID of the dictionary to update.
    ///   - newStatus: The new active status.
    ///   - completion: Closure called with the result of the operation.
    func updateStatus(
        dictionaryID: Int,
        newStatus: Bool,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        performDatabaseOperation(
            { try self.dictionaryRepository.updateStatus(dictionaryID: dictionaryID, newStatus: newStatus) },
            success: { _ in },
            screen: screenType,
            metadata: createStatusMetadata(dictionaryID: dictionaryID, newStatus: newStatus),
            completion: completion
        )
    }
    
    // MARK: - Private Methods
    
    /// Performs a database operation with common metadata creation and error handling.
    private func performOperation(
        _ operation: @escaping () throws -> Void,
        operation name: String,
        dictionary: DatabaseModelDictionary,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        Logger.debug("[Action]: Performing dictionary operation", metadata: [
            "operation": name,
            "dictionary": dictionary.name
        ])
        
        performDatabaseOperation(
            operation,
            success: { _ in },
            screen: screenType,
            metadata: createMetadata(operation: name, dictionary: dictionary),
            completion: completion
        )
    }
    
    /// Creates metadata for dictionary operations.
    private func createMetadata(operation: String, dictionary: DatabaseModelDictionary) -> [String: String] {
        [
            "operation": operation,
            "dictionary": dictionary.toString(),
            "frame": screen.rawValue
        ]
    }
    
    /// Creates metadata for status update operations.
    private func createStatusMetadata(dictionaryID: Int, newStatus: Bool) -> [String: String] {
        [
            "operation": "updateStatus",
            "dictionaryID": "\(dictionaryID)",
            "newStatus": "\(newStatus)",
            "frame": screen.rawValue
        ]
    }
}
