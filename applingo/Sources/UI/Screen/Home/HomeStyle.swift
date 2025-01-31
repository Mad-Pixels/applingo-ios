import SwiftUI

/// Defines styling properties for the Home view.
final class HomeStyle: ObservableObject {
    
    // MARK: - Properties
    
    /// The background color for the home screen.
    let backgroundColor: Color
    /// Padding applied to the content.
    let padding: EdgeInsets
    /// Spacing between elements.
    let spacing: CGFloat
    
    // MARK: - Initializer
    
    init(backgroundColor: Color, padding: EdgeInsets, spacing: CGFloat) {
        self.backgroundColor = backgroundColor
        self.padding = padding
        self.spacing = spacing
    }
}

// MARK: - Themed Style Extension

extension HomeStyle {
    /// Returns a themed style based on the current application theme.
    static func themed(_ theme: AppTheme) -> HomeStyle {
        HomeStyle(
            backgroundColor: theme.backgroundPrimary,
            padding: EdgeInsets(top: 32, leading: 24, bottom: 32, trailing: 24),
            spacing: 20
        )
    }
}
