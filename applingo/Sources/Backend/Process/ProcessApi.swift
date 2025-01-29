import Foundation
import Combine

/// A class that extends `BaseBackend` with `ObservableObject` functionality for managing API operations.
///
/// `ProcessApi` is designed to handle asynchronous API operations while integrating error handling
/// and providing reactive updates via the Combine framework.
class ProcessApi: BaseBackend, ObservableObject {
    
    /// A generic method to perform asynchronous API operations with error handling and success callbacks.
    ///
    /// - Parameters:
    ///   - operation: The asynchronous operation to be executed. This closure is expected to throw errors if something goes wrong.
    ///   - success: A closure called upon successful execution of the operation, passing the result of type `T`.
    ///   - screen: The screen type where the operation is performed, used for error tracking and context.
    ///   - metadata: Additional metadata associated with the operation, useful for debugging or logging purposes.
    ///   - completion: An optional closure called when the operation completes, with a `Result` indicating success or failure.
    func performApiOperation<T>(
        _ operation: @escaping () async throws -> T,
        success: @escaping (T) -> Void,
        screen: ScreenType,
        metadata: [String: Any] = [:],
        completion: ((Result<Void, Error>) -> Void)? = nil
    ) {
        Task {
            do {
                let result = try await operation()
                await MainActor.run {
                    success(result)
                    completion?(.success(()))
                }
            } catch {
                Logger.debug("Error: \(error)")
                await MainActor.run {
                    self.handleError(error, screen: screen, metadata: metadata)
                    completion?(.failure(error))
                }
            }
        }
    }
}
