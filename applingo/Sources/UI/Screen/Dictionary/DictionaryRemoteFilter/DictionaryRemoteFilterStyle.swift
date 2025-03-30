import SwiftUI

final class DictionaryRemoteFilterStyle: ObservableObject {
    // Colors
    let backgroundColor: Color

    // Layout
    let spacing: CGFloat
    let padding: EdgeInsets

    /// Initializes the DictionaryRemoteFilterStyle.
    /// - Parameters:
    ///   - backgroundColor: The background color for the filter view.
    ///   - padding: The padding applied to the filter view.
    ///   - spacing: The spacing between UI elements.
    init(
        backgroundColor: Color,
        padding: EdgeInsets,
        spacing: CGFloat
    ) {
        self.backgroundColor = backgroundColor
        self.spacing = spacing
        self.padding = padding
    }
}

extension DictionaryRemoteFilterStyle {
    static func themed(_ theme: AppTheme) -> DictionaryRemoteFilterStyle {
        DictionaryRemoteFilterStyle(
            backgroundColor: theme.backgroundPrimary,
            padding: EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16),
            spacing: 16
        )
    }
}
