import SwiftUI

/// Defines styling properties for the Home view.
final class HomeStyle: ObservableObject {
    // MARK: - Properties
    let backgroundColor: Color
    let padding: EdgeInsets
    let spacing: CGFloat

    // MARK: - Initializer
    /// Initializes a new instance of `HomeStyle`.
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

// MARK: - Themed Style Extension
extension HomeStyle {
    /// Returns a themed style based on the current application theme.
    /// - Parameter theme: The current application theme.
    /// - Returns: A new instance of `HomeStyle` configured for the given theme.
    static func themed(_ theme: AppTheme) -> HomeStyle {
        HomeStyle(
            backgroundColor: theme.backgroundPrimary,
            padding: EdgeInsets(top: 32, leading: 24, bottom: 32, trailing: 24),
            spacing: 20
        )
    }
}
