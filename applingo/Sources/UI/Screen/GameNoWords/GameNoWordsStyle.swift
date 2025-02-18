import SwiftUI

/// Defines styling properties for the GameNoWords view.
final class GameNoWordsStyle: ObservableObject {
    // MARK: - Properties
    let sectionSpacing: CGFloat
    let textFont: Font
    let textColor: Color
    let padding: EdgeInsets

    // MARK: - Initializer
    /// Initializes a new instance of `GameNoWordsStyle`.
    /// - Parameters:
    ///   - sectionSpacing: The spacing between elements in the section.
    ///   - textFont: The font used for the main text.
    ///   - textColor: The color of the main text.
    ///   - padding: The overall padding around the content.
    init(
        sectionSpacing: CGFloat,
        textFont: Font,
        textColor: Color,
        padding: EdgeInsets
    ) {
        self.sectionSpacing = sectionSpacing
        self.textFont = textFont
        self.textColor = textColor
        self.padding = padding
    }
}

// MARK: - Themed Style Extension
extension GameNoWordsStyle {
    /// Returns a themed style for the GameNoWords view based on the current app theme.
    /// - Parameter theme: The current application theme.
    /// - Returns: A new instance of `GameNoWordsStyle` configured for the given theme.
    static func themed(_ theme: AppTheme) -> GameNoWordsStyle {
        GameNoWordsStyle(
            sectionSpacing: 12,
            textFont: .system(size: 16, weight: .regular, design: .default),
            textColor: theme.textPrimary,
            padding: EdgeInsets(top: 12, leading: 8, bottom: 12, trailing: 8)
        )
    }
}
