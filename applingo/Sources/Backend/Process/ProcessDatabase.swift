import Foundation
import Combine

/// A class that extends `BaseBackend` with `ObservableObject` functionality for managing database operations.
///
/// `ProcessDatabase` is designed to handle synchronous database operations, providing centralized error handling
/// and success callbacks, while ensuring thread safety by executing operations on a background thread.
class ProcessDatabase: BaseBackend, ObservableObject {
    
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
}
