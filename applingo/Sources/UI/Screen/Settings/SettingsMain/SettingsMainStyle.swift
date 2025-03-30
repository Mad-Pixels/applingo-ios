import SwiftUI

final class SettingsMainStyle: ObservableObject {
    // Color
    let backgroundColor: Color
    let navIconColor: Color

    // Layout
    let padding: EdgeInsets
    let spacing: CGFloat

    /// Initializes the SettingsStyle.
    /// - Parameters:
    ///   - backgroundColor: The background color of the view.
    ///   - padding: The padding around the content.
    ///   - spacing: The spacing between elements.
    ///   - navIconColor: The color for nav icon.
    init(
        backgroundColor: Color,
        padding: EdgeInsets,
        spacing: CGFloat,
        navIconColor: Color
    ) {
        self.backgroundColor = backgroundColor
        self.navIconColor = navIconColor
        self.padding = padding
        self.spacing = spacing
    }
}

extension SettingsMainStyle {
    static func themed(_ theme: AppTheme) -> SettingsMainStyle {
        SettingsMainStyle(
            backgroundColor: theme.backgroundPrimary,
            padding: EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16),
            spacing: 16,
            navIconColor: theme.textSecondary
        )
    }
}
