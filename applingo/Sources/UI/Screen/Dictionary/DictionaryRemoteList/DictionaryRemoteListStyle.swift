import SwiftUI

final class DictionaryRemoteListStyle: ObservableObject {
    // Colors
    let backgroundColor: Color

    // Layout
    let padding: EdgeInsets
    let spacing: CGFloat

    // Icons
    let iconSize: CGFloat

    /// Initializes the DictionaryRemoteListStyle.
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
        iconSize: CGFloat
    ) {
        self.backgroundColor = backgroundColor
        self.padding = padding
        self.spacing = spacing
        self.iconSize = iconSize
    }
}

extension DictionaryRemoteListStyle {
    static func themed(_ theme: AppTheme) -> DictionaryRemoteListStyle {
        DictionaryRemoteListStyle(
            backgroundColor: theme.backgroundPrimary,
            padding: EdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 16),
            spacing: 16,
            iconSize: 215
        )
    }
}
