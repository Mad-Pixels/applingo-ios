import SwiftUI

/// Defines styling properties for the WordList view.
final class WordListStyle: ObservableObject {
    // Color Properties
    let backgroundColor: Color

    // Layout Properties
    let padding: EdgeInsets
    let spacing: CGFloat

    // Icon Properties
    let iconSize: CGFloat

    init(
        spacing: CGFloat,
        padding: EdgeInsets,
        backgroundColor: Color,
        iconSize: CGFloat
    ) {
        self.spacing = spacing
        self.padding = padding
        self.backgroundColor = backgroundColor
        self.iconSize = iconSize
    }
}

extension WordListStyle {
    static func themed(_ theme: AppTheme) -> WordListStyle {
        WordListStyle(
            spacing: 16,
            padding: EdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16),
            backgroundColor: theme.backgroundPrimary,
            iconSize: 215
        )
    }
}
