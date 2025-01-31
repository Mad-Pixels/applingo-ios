import SwiftUI

/// Defines styling properties for the GameQuiz view.
final class GameQuizStyle: ObservableObject {
    
    // MARK: - Properties
    
    /// Background color for the quiz view.
    let backgroundColor: Color
    
    // MARK: - Initializer
    
    init(backgroundColor: Color) {
        self.backgroundColor = backgroundColor
    }
}

// MARK: - Themed Style Extension

extension GameQuizStyle {
    /// Returns a themed style based on the current application theme.
    static func themed(_ theme: AppTheme) -> GameQuizStyle {
        GameQuizStyle(
            backgroundColor: theme.accentPrimary
        )
    }
}
