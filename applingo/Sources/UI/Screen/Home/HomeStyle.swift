import SwiftUI

final class HomeStyle: ObservableObject {
    // Colors
    let backgroundColor: Color

    // Layout
    let padding: EdgeInsets
    let spacing: CGFloat

    /// Initializes the HomeStyle.
    /// - Parameters:
    ///   - backgroundColor: The background color of the view.
    ///   - padding: The overall padding around the content.
    ///   - spacing: The spacing between individual UI elements.
    init(backgroundColor: Color, padding: EdgeInsets, spacing: CGFloat) {
        self.backgroundColor = backgroundColor
        self.padding = padding
        self.spacing = spacing
    }
}

extension HomeStyle {
    static func themed(_ theme: AppTheme) -> HomeStyle {
        HomeStyle(
            backgroundColor: theme.backgroundPrimary,
            padding: EdgeInsets(top: 32, leading: 24, bottom: 32, trailing: 24),
            spacing: 20
        )
    }
}
