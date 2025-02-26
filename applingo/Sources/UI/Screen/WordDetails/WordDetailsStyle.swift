import SwiftUI

/// Defines styling properties for the WordDetails view.
final class WordDetailsStyle: ObservableObject {
    // MARK: - Properties
    let backgroundColor: Color
    let sectionBackgroundColor: Color
    let accentColor: Color
    let disabledColor: Color
    let padding: EdgeInsets
    let paddingBlock: CGFloat
    let spacing: CGFloat
    let sectionSpacing: CGFloat
    let titleFont: Font
    let iconSize: CGFloat

    // MARK: - Initializer
    /// Initializes a new instance of `WordDetailsStyle`.
    /// - Parameters:
    ///   - backgroundColor: The primary background color.
    ///   - sectionBackgroundColor: The background color used for sections.
    ///   - accentColor: The accent color.
    ///   - disabledColor: The color for disabled elements.
    ///   - padding: The padding around the content.
    ///   - spacing: The spacing between individual elements.
    ///   - sectionSpacing: The spacing between sections.
    ///   - iconSize: The size of icons.
    init(
        backgroundColor: Color,
        sectionBackgroundColor: Color,
        accentColor: Color,
        disabledColor: Color,
        padding: EdgeInsets,
        paddingBlock: CGFloat,
        spacing: CGFloat,
        sectionSpacing: CGFloat,
        titleFont: Font,
        iconSize: CGFloat
    ) {
        self.backgroundColor = backgroundColor
        self.sectionBackgroundColor = sectionBackgroundColor
        self.accentColor = accentColor
        self.disabledColor = disabledColor
        self.padding = padding
        self.paddingBlock = paddingBlock
        self.spacing = spacing
        self.sectionSpacing = sectionSpacing
        self.titleFont = titleFont
        self.iconSize = iconSize
    }
}

// MARK: - Themed Style Extension
extension WordDetailsStyle {
    /// Returns a themed style based on the current application theme.
    /// - Parameter theme: The current application theme.
    /// - Returns: A new instance of `WordDetailsStyle` configured for the given theme.
    static func themed(_ theme: AppTheme) -> WordDetailsStyle {
        WordDetailsStyle(
            backgroundColor: theme.backgroundPrimary,
            sectionBackgroundColor: theme.backgroundSecondary,
            accentColor: theme.accentPrimary,
            disabledColor: theme.textSecondary.opacity(0.5),
            padding: EdgeInsets(top: 16, leading: 16, bottom: 32, trailing: 16),
            paddingBlock: 8,
            spacing: 24,
            sectionSpacing: 16,
            titleFont: .system(size: 20, weight: .bold),
            iconSize: 196
        )
    }
}
