import SwiftUI

/// Defines styling properties for the WordList view.
final class WordListStyle: ObservableObject {
    // Color Properties
    let backgroundColor: Color
    let accentColor: Color

    // Layout Properties
    let padding: EdgeInsets
    let spacing: CGFloat

    // Icon Properties
    let iconSize: CGFloat

    init(
        spacing: CGFloat,
        padding: EdgeInsets,
        backgroundColor: Color,
        accentColor: Color,
        iconSize: CGFloat
    ) {
        self.spacing = spacing
        self.padding = padding
        self.backgroundColor = backgroundColor
        self.accentColor = accentColor
        self.iconSize = iconSize
    }
}

extension WordListStyle {
    static func themed(_ theme: AppTheme) -> WordListStyle {
        WordListStyle(
            spacing: 16,
            padding: EdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16),
            backgroundColor: theme.backgroundPrimary,
            accentColor: theme.accentPrimary,
            iconSize: 215
        )
    }
}
