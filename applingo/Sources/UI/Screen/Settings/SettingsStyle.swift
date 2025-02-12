import SwiftUI

/// Defines styling properties for the Settings view.
final class SettingsStyle: ObservableObject {
    // MARK: - Properties
    let backgroundColor: Color
    let padding: EdgeInsets
    let spacing: CGFloat

    // MARK: - Initializer
    /// Initializes a new instance of `SettingsStyle`.
    /// - Parameters:
    ///   - spacing: The spacing between elements.
    ///   - padding: The padding around the content.
    ///   - backgroundColor: The background color of the view.
    init(spacing: CGFloat, padding: EdgeInsets, backgroundColor: Color) {
        self.spacing = spacing
        self.padding = padding
        self.backgroundColor = backgroundColor
    }
}

// MARK: - Themed Style Extension
extension SettingsStyle {
    /// Returns a themed style based on the current application theme.
    /// - Parameter theme: The current application theme.
    /// - Returns: A new instance of `SettingsStyle` configured for the given theme.
    static func themed(_ theme: AppTheme) -> SettingsStyle {
        SettingsStyle(
            spacing: 24,
            padding: EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16),
            backgroundColor: theme.backgroundPrimary
        )
    }
}
