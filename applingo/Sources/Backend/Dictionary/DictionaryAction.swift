import Foundation
import Combine
import GRDB

/// A class responsible for performing CRUD operations on dictionaries in the database.
/// Provides validation and error handling for all dictionary operations.
final class DictionaryAction: ProcessDatabase {
    // MARK: - Private Properties
    
    private let dictionaryRepository: DatabaseManagerDictionary
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    
    /// Initializes a new instance of `DictionaryAction` by retrieving the database queue from the shared AppDatabase.
    init() {
        guard let dbQueue = AppDatabase.shared.databaseQueue else {
            fatalError("Database is not connected")
        }
        self.dictionaryRepository = DatabaseManagerDictionary(dbQueue: dbQueue)
        super.init(dbQueue: dbQueue)
    }
    
    // MARK: - CRUD Operations
    
    /// Saves a new dictionary to the database with validation.
    /// - Parameters:
    ///   - dictionary: The dictionary to save.
    ///   - completion: Called with the result of the operation.
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
    
    /// Updates an existing dictionary in the database with validation.
    /// - Parameters:
    ///   - dictionary: The dictionary to update.
    ///   - completion: Called with the result of the operation.
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
    
    /// Deletes a dictionary from the database with validation.
    /// - Parameters:
    ///   - dictionary: The dictionary to delete.
    ///   - completion: Called with the result of the operation.
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
            completion: { result in
                switch result {
                case .failure(let error):
                    completion(.failure(error))
                case .success:
                    if !dictionary.isLocal {
                        Task {
                            do {
                                try await ApiManagerRequest().patchDictionaryStatistic(
                                    request: ApiModelDictionaryStatisticRequest.onDelete(),
                                    name: dictionary.name,
                                    author: dictionary.author,
                                    subcategory: dictionary.subcategory
                                )
                                Logger.debug("[Dictionary]: Dictionary statistic patched successfully for deletion")
                            } catch {
                                Logger.warning(
                                    "[Dictionary]: Failed to patch dictionary statistic on deletion",
                                    metadata: ["error": error.localizedDescription]
                                )
                            }
                            completion(.success(()))
                        }
                    } else {
                        completion(.success(()))
                    }
                }
            }
        )
    }
    
    /// Checks if a dictionary exists in the database.
    /// - Parameters:
    ///   - guid: The GUID of the dictionary to check.
    ///   - completion: Called with the result of the operation (true if exists, false otherwise).
    func exists(guid: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        if guid.isEmpty {
            Logger.warning(
                "[Dictionary]: Attempted to check existence with empty GUID",
                metadata: ["guid": guid, "operation": "exists", "screen": screen.rawValue]
            )
            completion(.success(false))
            return
        }
        
        performDatabaseOperationWithResult(
            { try self.dictionaryRepository.exists(guid: guid) },
            screen: screen,
            metadata: [
                "guid": guid,
                "operation": "exists",
                "screen": screen.rawValue
            ]
        )
        .sink { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .finished:
                break
            }
        } receiveValue: { value in
            completion(.success(value))
        }
        .store(in: &cancellables)
    }
    
    /// Updates the active status of a dictionary.
    /// - Parameters:
    ///   - dictionaryID: The ID of the dictionary to update.
    ///   - newStatus: The new active status.
    ///   - completion: Called with the result of the operation.
    func updateStatus(
        dictionaryID: Int,
        newStatus: Bool,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        performDatabaseOperation(
            { try self.dictionaryRepository.updateStatus(dictionaryID: dictionaryID, newStatus: newStatus) },
            screen: screen,
            metadata: createStatusMetadata(dictionaryID: dictionaryID, newStatus: newStatus)
        )
        .sink { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .finished:
                break
            }
        } receiveValue: { _ in
            Logger.debug(
                "[Dictionary]: Status updated successfully",
                metadata: [
                    "dictionaryId": String(dictionaryID),
                    "newStatus": String(newStatus)
                ]
            )
            completion(.success(()))
        }
        .store(in: &cancellables)
    }
    
    // MARK: - Fetch References
    
    /// Fetches all dictionary references (with only name and guid).
    /// - Returns: An array of DatabaseModelDictionaryRef objects.
    func fetchRefs() throws -> [DatabaseModelDictionaryRef] {
        try dictionaryRepository.fetchRefs()
    }
    
    // MARK: - Private Methods
    
    /// Performs a database operation with logging and error handling.
    /// - Parameters:
    ///   - operation: The database operation to execute.
    ///   - operation name: The name of the operation.
    ///   - dictionary: The dictionary involved in the operation.
    ///   - completion: Called with the result of the operation.
    private func performOperation(
        _ operation: @escaping () throws -> Void,
        operation name: String,
        dictionary: DatabaseModelDictionary,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        performDatabaseOperation(
            operation,
            screen: screen,
            metadata: createMetadata(operation: name, dictionary: dictionary)
        )
        .sink { result in
            switch result {
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
    
    /// Creates metadata for dictionary operations.
    /// - Parameters:
    ///   - operation: The operation name.
    ///   - dictionary: The dictionary involved in the operation.
    /// - Returns: A dictionary containing metadata.
    private func createMetadata(operation: String, dictionary: DatabaseModelDictionary) -> [String: String] {
        [
            "dictionaryId": dictionary.id.map(String.init) ?? "nil",
            "dictionaryName": dictionary.name,
            "dictionaryGuid": dictionary.guid,
            "screen": screen.rawValue,
            "operation": operation
        ]
    }
    
    /// Creates metadata for status update operations.
    /// - Parameters:
    ///   - dictionaryID: The ID of the dictionary.
    ///   - newStatus: The new status.
    /// - Returns: A dictionary containing metadata.
    private func createStatusMetadata(dictionaryID: Int, newStatus: Bool) -> [String: String] {
        [
            "dictionaryId": String(dictionaryID),
            "newStatus": String(newStatus),
            "operation": "updateStatus",
            "screen": screen.rawValue
        ]
    }
}
