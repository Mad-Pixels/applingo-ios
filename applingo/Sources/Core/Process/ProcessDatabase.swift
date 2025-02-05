import Foundation
import Combine
import GRDB

/// A class that extends `ErrorWrapper` with `ObservableObject` functionality for managing database operations.
///
/// `ProcessDatabase` is designed to handle synchronous database operations, providing centralized error handling
/// and success callbacks, while ensuring thread safety by executing operations on a background thread.
class ProcessDatabase: ErrorWrapper, ObservableObject {
    
    /// A generic method to perform synchronous database operations with error handling and success callbacks.
    ///
    /// - Parameters:
    ///   - operation: The database operation to be executed. This closure is expected to throw errors if something goes wrong.
    ///   - success: A closure called upon successful execution of the operation, passing the result of type `T`.
    ///   - screen: The screen type where the operation is performed, used for error tracking and context.
    ///   - metadata: Additional metadata associated with the operation, useful for debugging or logging purposes.
    ///   - completion: An optional closure called when the operation completes, with a `Result` indicating success or failure.
    func performDatabaseOperation<T>(
        _ operation: @escaping () throws -> T,
        success: @escaping (T) -> Void,
        screen: ScreenType,
        metadata: [String: Any] = [:],
        completion: ((Result<Void, Error>) -> Void)? = nil
    ) {
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let result = try operation()
                
                DispatchQueue.main.async {
                    success(result)
                    completion?(.success(()))
                }
            } catch {
                DispatchQueue.main.async {
                    self.handleError(error, screen: screen, metadata: metadata)
                    completion?(.failure(error))
                }
            }
        }
    }
    
    /// A generic method to perform database operations wrapped in a transaction.
    ///
    /// This method ensures that the provided operation is executed within a transaction
    /// (using `dbQueue.write { ... }`), so that if an error occurs, all changes are rolled back.
    ///
    /// - Parameters:
    ///   - operation: The database operation to be executed within a transaction. The closure receives a `Database` instance.
    ///   - success: A closure called upon successful execution of the operation, passing the result of type `T`.
    ///   - screen: The screen type where the operation is performed, used for error tracking and context.
    ///   - metadata: Additional metadata associated with the operation, useful for debugging or logging purposes.
    ///   - completion: An optional closure called when the operation completes, with a `Result` indicating success or failure.
    func performDatabaseTransactionOperation<T>(
        _ operation: @escaping (Database) throws -> T,
        success: @escaping (T) -> Void,
        screen: ScreenType,
        metadata: [String: Any] = [:],
        completion: ((Result<Void, Error>) -> Void)? = nil
    ) {
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                guard let dbQueue = AppDatabase.shared.databaseQueue else {
                    throw DatabaseError.connectionFailed(details: "Database connection is not established")
                }
                
                let result = try dbQueue.write { db in
                    return try operation(db)
                }
                
                DispatchQueue.main.async {
                    success(result)
                    completion?(.success(()))
                }
            } catch {
                DispatchQueue.main.async {
                    self.handleError(error, screen: screen, metadata: metadata)
                    completion?(.failure(error))
                }
            }
        }
    }
}
