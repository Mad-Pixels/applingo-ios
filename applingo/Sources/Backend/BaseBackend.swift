import Foundation

/// A base class for backend operations, providing common functionality for handling errors.
class BaseBackend {

    /// Handles errors by passing them to the shared `ErrorManager` for processing.
    ///
    /// - Parameters:
    ///   - error: The error to be processed.
    ///   - screen: The screen type where the error occurred, used for tracking context.
    ///   - metadata: Additional metadata associated with the error for debugging or logging purposes.
    func handleError(_ error: Error, screen: ScreenType, metadata: [String: Any] = [:]) {
        ErrorManager.shared.process(error, screen: screen, metadata: metadata)
    }
}
