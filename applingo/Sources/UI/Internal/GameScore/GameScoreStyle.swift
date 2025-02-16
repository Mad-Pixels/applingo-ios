import SwiftUI

final class GameScoreStyle: ObservableObject {
    // MARK: - Properties
    let positiveTextColor: Color
    let negativeTextColor: Color
    let iconSize: CGFloat
    let font: Font

    // MARK: - Initializer
    /// Initializes a new instance of `GameScoreStyle`.
    /// - Parameters:
    ///   - textColor: The color of the score text.
    ///   - iconSize: The size of the icon.
    ///   - font: The font used for displaying the score.
    init(
        positiveTextColor: Color,
        negativeTextColor: Color,
        iconSize: CGFloat,
        font: Font
    ) {
        self.positiveTextColor = positiveTextColor
        self.negativeTextColor = negativeTextColor
        self.iconSize = iconSize
        self.font = font
    }
}

// MARK: - Themed Style Extension
extension GameScoreStyle {
    /// Returns a themed style based on the current application theme.
    /// - Parameter theme: The current application theme.
    /// - Returns: A new instance of `GameScoreStyle` configured for the given theme.
    static func themed(_ theme: AppTheme) -> GameScoreStyle {
        GameScoreStyle(
            positiveTextColor: theme.success,
            negativeTextColor: theme.errorPrimaryColor,
            iconSize: 16,
            font: .system(size: 16, weight: .bold)
        )
    }
}
