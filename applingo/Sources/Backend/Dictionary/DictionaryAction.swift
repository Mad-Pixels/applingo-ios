import Foundation
import Combine
import GRDB

/// A class responsible for performing CRUD operations on dictionaries in the database.
/// Provides validation and error handling for all dictionary operations.
final class DictionaryAction: ProcessDatabase {
    // MARK: - Private Properties
    
    private let dictionaryRepository: DatabaseManagerDictionary
    
    // MARK: - Initialization
    
    override init() {
        guard let dbQueue = AppDatabase.shared.databaseQueue else {
            Logger.error("[Dictionary]: Database not connected during initialization")
            fatalError("Database is not connected")
        }
        self.dictionaryRepository = DatabaseManagerDictionary(dbQueue: dbQueue)
        super.init()
        Logger.info("[Dictionary]: Initialized successfully")
    }
        
    // MARK: - CRUD Operations
    
    /// Saves a new dictionary to the database with validation
    /// - Parameters:
    ///   - dictionary: The dictionary to save
    ///   - completion: Called with the result of the operation
    func save(_ dictionary: DatabaseModelDictionary, completion: @escaping (Result<Void, Error>) -> Void) {
        if dictionary.name.isEmpty {
            Logger.warning(
                "[Dictionary]: Attempted to save dictionary with empty name",
                metadata: createMetadata(operation: "save", dictionary: dictionary)
            )
        }
        
        performOperation(
            { try self.dictionaryRepository.save(dictionary) },
            operation: "save",
            dictionary: dictionary,
            completion: completion
        )
    }
    
    /// Updates an existing dictionary in the database with validation
    /// - Parameters:
    ///   - dictionary: The dictionary to update
    ///   - completion: Called with the result of the operation
    func update(_ dictionary: DatabaseModelDictionary, completion: @escaping (Result<Void, Error>) -> Void) {
        if dictionary.name.isEmpty {
            Logger.warning(
                "[Dictionary]: Attempted to update dictionary with empty name",
                metadata: createMetadata(operation: "update", dictionary: dictionary)
            )
        }
        
        performOperation(
            { try self.dictionaryRepository.update(dictionary) },
            operation: "update",
            dictionary: dictionary,
            completion: completion
        )
    }
    
    /// Deletes a dictionary from the database with validation
    /// - Parameters:
    ///   - dictionary: The dictionary to delete
    ///   - completion: Called with the result of the operation
    func delete(_ dictionary: DatabaseModelDictionary, completion: @escaping (Result<Void, Error>) -> Void) {
        if dictionary.guid == "Internal" {
            Logger.warning(
                "[Dictionary]: Attempted to delete internal dictionary",
                metadata: createMetadata(operation: "delete", dictionary: dictionary)
            )
        }
        
        performOperation(
            { try self.dictionaryRepository.delete(dictionary) },
            operation: "delete",
            dictionary: dictionary,
            completion: completion
        )
    }
    
    /// Updates the active status of a dictionary
    /// - Parameters:
    ///   - dictionaryID: The ID of the dictionary to update
    ///   - newStatus: The new active status
    ///   - completion: Called with the result of the operation
    func updateStatus(
        dictionaryID: Int,
        newStatus: Bool,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        Logger.info(
            "[Dictionary]: Updating dictionary status",
            metadata: [
                "dictionaryId": String(dictionaryID),
                "newStatus": String(newStatus)
            ]
        )
        
        performDatabaseOperation(
            { try self.dictionaryRepository.updateStatus(dictionaryID: dictionaryID, newStatus: newStatus) },
            success: { _ in
                Logger.info(
                    "[Dictionary]: Status updated successfully",
                    metadata: [
                        "dictionaryId": String(dictionaryID),
                        "newStatus": String(newStatus)
                    ]
                )
            },
            screen: screen,
            metadata: createStatusMetadata(dictionaryID: dictionaryID, newStatus: newStatus),
            completion: completion
        )
    }
    
    // MARK: - Private Methods
    
    /// Performs a database operation with logging and error handling
    private func performOperation(
        _ operation: @escaping () throws -> Void,
        operation name: String,
        dictionary: DatabaseModelDictionary,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        Logger.debug(
            "[Dictionary]: Performing operation",
            metadata: [
                "operation": name,
                "dictionary": dictionary.name
            ]
        )
        
        performDatabaseOperation(
            operation,
            success: { _ in
                Logger.info(
                    "[Dictionary]: Operation completed successfully",
                    metadata: [
                        "operation": name,
                        "dictionary": dictionary.name
                    ]
                )
            },
            screen: screen,
            metadata: createMetadata(operation: name, dictionary: dictionary),
            completion: completion
        )
    }
    
    /// Creates metadata for dictionary operations
    private func createMetadata(operation: String, dictionary: DatabaseModelDictionary) -> [String: String] {
        [
            "operation": operation,
            "dictionaryId": dictionary.id.map(String.init) ?? "nil",
            "dictionaryName": dictionary.name,
            "dictionaryGuid": dictionary.guid,
            "frame": screen.rawValue
        ]
    }
    
    /// Creates metadata for status update operations
    private func createStatusMetadata(dictionaryID: Int, newStatus: Bool) -> [String: String] {
        [
            "operation": "updateStatus",
            "dictionaryId": String(dictionaryID),
            "newStatus": String(newStatus),
            "frame": screen.rawValue
        ]
    }
}
