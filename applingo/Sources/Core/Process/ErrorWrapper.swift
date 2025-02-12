import Foundation

/// A base class for backend operations, providing common functionality for handling errors and frame tracking.
class ErrorWrapper {
    /// The current frame type for tracking context
    private(set) var screen: ScreenType = .Home
    
    /// Sets the current frame type for tracking context.
    /// - Parameter newScreen: The frame type to set.
    func setScreen(_ newScreen: ScreenType) {
        Logger.debug(
            "[ErrorWrapper]: Setting frame",
            metadata: [
                "oldFrame": screen.rawValue,
                "newFrame": newScreen.rawValue
            ]
        )
        self.screen = newScreen
    }
    
    /// Handles errors by passing them to the shared `ErrorManager` for processing.
    /// - Parameters:
    ///   - error: The error to be processed.
    ///   - screen: The screen type where the error occurred, used for tracking context.
    ///   - metadata: Additional metadata associated with the error for debugging or logging purposes.
    func handleError(_ error: Error, screen: ScreenType, metadata: [String: Any] = [:]) {
        ErrorManager.shared.process(error, screen: screen, metadata: metadata)
    }
}
