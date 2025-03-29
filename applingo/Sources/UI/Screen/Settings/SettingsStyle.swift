import SwiftUI

final class SettingsStyle: ObservableObject {
    let backgroundColor: Color

    let padding: EdgeInsets
    let spacing: CGFloat

    /// Initializes the SettingsStyle.
    /// - Parameters:
    ///   - spacing: The spacing between elements.
    ///   - padding: The padding around the content.
    ///   - backgroundColor: The background color of the view.
    init(spacing: CGFloat, padding: EdgeInsets, backgroundColor: Color) {
        self.backgroundColor = backgroundColor
        self.spacing = spacing
        self.padding = padding
    }
}

extension SettingsStyle {
    static func themed(_ theme: AppTheme) -> SettingsStyle {
        SettingsStyle(
            spacing: 24,
            padding: EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16),
            backgroundColor: theme.backgroundPrimary
        )
    }
}
