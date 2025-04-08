import SwiftUI

final class WordDetailsStyle: ObservableObject {
    // Color Properties
    let backgroundColor: Color
    let sectionBackgroundColor: Color
    let accentColor: Color
    let disabledColor: Color

    // Layout Properties
    let padding: EdgeInsets
    let paddingBlock: CGFloat
    let spacing: CGFloat
    let sectionSpacing: CGFloat

    // Icon Properties
    let iconSize: CGFloat

    /// Initializes the WordDetailsStyle.
    /// - Parameters:
    ///   - backgroundColor: The primary background color.
    ///   - sectionBackgroundColor: The background color used for sections.
    ///   - accentColor: The accent color for interactive elements.
    ///   - disabledColor: The color for disabled elements.
    ///   - padding: The padding around the content.
    ///   - paddingBlock: Vertical padding specifically for header blocks.
    ///   - spacing: The spacing between individual elements.
    ///   - sectionSpacing: The spacing between sections.
    ///   - titleFont: The font used for titles.
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
        self.iconSize = iconSize
    }
}

extension WordDetailsStyle {
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
            iconSize: 196
        )
    }
}
