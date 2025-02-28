import SwiftUI

/// Defines styling properties for the WordList view.
final class WordListStyle: ObservableObject {
    // MARK: - Properties
    let backgroundColor: Color
    let padding: EdgeInsets
    let spacing: CGFloat
    let titleFont: Font
    let iconSize: CGFloat

    // MARK: - Initializer
    /// Initializes a new instance of `WordListStyle`.
    /// - Parameters:
    ///   - spacing: The spacing between elements.
    ///   - padding: The padding around the content.
    ///   - backgroundColor: The background color.
    ///   - titleFont: The font used for titles.
    ///   - iconSize: The size of icons.
    init(
        spacing: CGFloat,
        padding: EdgeInsets,
        backgroundColor: Color,
        titleFont: Font,
        iconSize: CGFloat
    ) {
        self.spacing = spacing
        self.padding = padding
        self.backgroundColor = backgroundColor
        self.titleFont = titleFont
        self.iconSize = iconSize
    }
}

// MARK: - Themed Style Extension
extension WordListStyle {
    /// Returns a themed style based on the current application theme.
    /// - Parameter theme: The current application theme.
    /// - Returns: A new instance of `WordListStyle` configured for the given theme.
    static func themed(_ theme: AppTheme) -> WordListStyle {
        WordListStyle(
            spacing: 16,
            padding: EdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16),
            backgroundColor: theme.backgroundPrimary,
            titleFont: .system(size: 24, weight: .bold),
            iconSize: 215
        )
    }
}
