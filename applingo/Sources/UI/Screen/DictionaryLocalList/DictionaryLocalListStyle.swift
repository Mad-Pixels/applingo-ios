import SwiftUI

/// Defines styling properties for the Dictionary Local List view.
final class DictionaryLocalListStyle: ObservableObject {
    // MARK: - Properties
    let backgroundColor: Color
    let padding: EdgeInsets
    let spacing: CGFloat
    let titleFont: Font
    let iconSize: CGFloat

    // MARK: - Initializer
    /// Initializes a new instance of `DictionaryLocalListStyle`.
    /// - Parameters:
    ///   - backgroundColor: The primary background color for the view.
    ///   - padding: The padding around the content.
    ///   - spacing: The spacing between individual elements.
    ///   - titleFont: The font used for section headers.
    ///   - iconSize: The size of icons used in the view.
    init(
        backgroundColor: Color,
        padding: EdgeInsets,
        spacing: CGFloat,
        titleFont: Font,
        iconSize: CGFloat
    ) {
        self.backgroundColor = backgroundColor
        self.padding = padding
        self.spacing = spacing
        self.titleFont = titleFont
        self.iconSize = iconSize
    }
}

// MARK: - Themed Style Extension
extension DictionaryLocalListStyle {
    /// Returns a themed style based on the current application theme.
    /// - Parameter theme: The current application theme.
    /// - Returns: A new instance of `DictionaryLocalListStyle` configured for the given theme.
    static func themed(_ theme: AppTheme) -> DictionaryLocalListStyle {
        DictionaryLocalListStyle(
            backgroundColor: theme.backgroundPrimary,
            padding: EdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16),
            spacing: 16,
            titleFont: .system(size: 24, weight: .bold),
            iconSize: 215
        )
    }
}
