import SwiftUI

final class DictionaryRemoteDetailsStyle: ObservableObject {
    // Colors
    let backgroundColor: Color

    // Layout
    let padding: EdgeInsets
    let spacing: CGFloat

    /// Initializes the DictionaryRemoteDetailsStyle.
    /// - Parameters:
    ///   - backgroundColor: The background color for the view.
    ///   - padding: The padding around the content.
    ///   - spacing: The spacing between UI elements.
    init(backgroundColor: Color, padding: EdgeInsets, spacing: CGFloat) {
        self.backgroundColor = backgroundColor
        self.padding = padding
        self.spacing = spacing
    }
}

extension DictionaryRemoteDetailsStyle {
    static func themed(_ theme: AppTheme) -> DictionaryRemoteDetailsStyle {
        DictionaryRemoteDetailsStyle(
            backgroundColor: theme.backgroundPrimary,
            padding: EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16),
            spacing: 16
        )
    }
}
