import SwiftUI

/// Defines styling properties for the WordList view.
final class WordListStyle: ObservableObject {
    // Color Properties
    let backgroundColor: Color

    // Layout Properties
    let padding: EdgeInsets
    let spacing: CGFloat

    // Font Properties
    let titleFont: Font

    // Icon Properties
    let iconSize: CGFloat

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

extension WordListStyle {
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
