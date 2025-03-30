import SwiftUI

final class DictionaryLocalListStyle: ObservableObject {
    // Colors
    let backgroundColor: Color

    // Layout
    let padding: EdgeInsets
    let spacing: CGFloat

    // Typography & Icons
    let titleFont: Font
    let iconSize: CGFloat

    /// Initializes the DictionaryLocalListStyle.
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

extension DictionaryLocalListStyle {
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
