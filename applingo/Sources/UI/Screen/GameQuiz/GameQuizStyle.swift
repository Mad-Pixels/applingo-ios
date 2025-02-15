import SwiftUI

/// Defines styling properties for the GameQuiz view.
///
/// This class encapsulates style-related information for the quiz interface,
/// such as the background color. It conforms to `ObservableObject` to allow
/// SwiftUI views to react to any changes in style properties if needed.
final class GameQuizStyle: ObservableObject {
    
    // MARK: - Properties
    
    /// The background color for the quiz view.
    let backgroundColor: Color
    
    // MARK: - Initializer
    
    /// Initializes a new instance of `GameQuizStyle` with the specified background color.
    ///
    /// - Parameter backgroundColor: The color to be used as the background for the quiz view.
    init(backgroundColor: Color) {
        self.backgroundColor = backgroundColor
    }
}

// MARK: - Themed Style Extension

extension GameQuizStyle {
    
    /// Returns a themed style based on the current application theme.
    ///
    /// This convenience method creates a `GameQuizStyle` instance using the accent
    /// color from the provided `AppTheme`. This allows the quiz view's appearance
    /// to adapt to the overall application theme.
    ///
    /// - Parameter theme: The current application theme.
    /// - Returns: A new instance of `GameQuizStyle` configured with the theme's accent primary color.
    static func themed(_ theme: AppTheme) -> GameQuizStyle {
        GameQuizStyle(
            backgroundColor: theme.accentPrimary
        )
    }
}
