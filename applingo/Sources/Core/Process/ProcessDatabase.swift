import Foundation
import Combine
import GRDB

// MARK: - ProcessDatabaseError

/// An error indicating that `self` has been deallocated.
enum ProcessDatabaseError: Error {
    case selfDeallocated
}

// MARK: - ProcessDatabase

/// A class that extends `ErrorWrapper` with `ObservableObject` functionality for managing database operations.
///
/// `ProcessDatabase` is designed to handle synchronous database operations, providing centralized error handling
/// and success callbacks, while ensuring thread safety by executing operations on a background thread.
class ProcessDatabase: ErrorWrapper, ObservableObject {
    
    /// Dependency injection of the database queue instead of using a singleton.
    private let dbQueue: DatabaseQueue
    
    /// Initializes a new instance of `ProcessDatabase` with the provided database queue.
    /// - Parameter dbQueue: The injected database queue.
    init(dbQueue: DatabaseQueue) {
        self.dbQueue = dbQueue
    }
    
    /// A generic method to perform synchronous database operations with error handling.
    ///
    /// - Parameters:
    ///   - operation: The database operation to be executed. This closure is expected to throw errors if something goes wrong.
    ///   - screen: The screen type where the operation is performed, used for error tracking and context.
    ///   - metadata: Additional metadata associated with the operation, useful for debugging or logging purposes.
    /// - Returns: A publisher that emits the result of type `T` on success or an error on failure.
    func performDatabaseOperation<T>(
        _ operation: @escaping () throws -> T,
        screen: ScreenType,
        metadata: [String: Any] = [:]
    ) -> AnyPublisher<T, Error> {
        Future { [weak self] promise in
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                guard let self = self else {
                    DispatchQueue.main.async {
                        promise(.failure(ProcessDatabaseError.selfDeallocated))
                    }
                    return
                }
                do {
                    let result = try operation()
                    DispatchQueue.main.async {
                        promise(.success(result))
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.handleError(error, screen: screen, metadata: metadata)
                        promise(.failure(error))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    /// A generic method to perform database operations wrapped in a transaction.
    ///
    /// This method ensures that the provided operation is executed within a transaction
    /// (using `dbQueue.write { ... }`), so that if an error occurs, all changes are rolled back.
    ///
    /// - Parameters:
    ///   - operation: The database operation to be executed within a transaction. The closure receives a `Database` instance.
    ///   - screen: The screen type where the operation is performed, used for error tracking and context.
    ///   - metadata: Additional metadata associated with the operation, useful for debugging or logging purposes.
    /// - Returns: A publisher that emits the result of type `T` on success or an error on failure.
    func performDatabaseTransactionOperation<T>(
        _ operation: @escaping (Database) throws -> T,
        screen: ScreenType,
        metadata: [String: Any] = [:]
    ) -> AnyPublisher<T, Error> {
        Future { [weak self] promise in
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                guard let self = self else {
                    DispatchQueue.main.async {
                        promise(.failure(ProcessDatabaseError.selfDeallocated))
                    }
                    return
                }
                do {
                    let result = try self.dbQueue.write { db in
                        try operation(db)
                    }
                    DispatchQueue.main.async {
                        promise(.success(result))
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.handleError(error, screen: screen, metadata: metadata)
                        promise(.failure(error))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    /// A method to perform synchronous database operations with value return and error handling.
    ///
    /// Similar to `performDatabaseOperation`, but designed specifically for operations that need to return
    /// a value in the completion handler. This is useful for queries and checks that need to return data.
    ///
    /// - Parameters:
    ///   - operation: The database operation to be executed. This closure is expected to throw errors if something goes wrong.
    ///   - screen: The screen type where the operation is performed, used for error tracking and context.
    ///   - metadata: Additional metadata associated with the operation, useful for debugging or logging purposes.
    /// - Returns: A publisher that emits the operation's result of type `T` on success or an error on failure.
    func performDatabaseOperationWithResult<T>(
       _ operation: @escaping () throws -> T,
       screen: ScreenType,
       metadata: [String: Any] = [:]
    ) -> AnyPublisher<T, Error> {
        Future { [weak self] promise in
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                guard let self = self else {
                    DispatchQueue.main.async {
                        promise(.failure(ProcessDatabaseError.selfDeallocated))
                    }
                    return
                }
                do {
                    let result = try operation()
                    DispatchQueue.main.async {
                        promise(.success(result))
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.handleError(error, screen: screen, metadata: metadata)
                        promise(.failure(error))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
