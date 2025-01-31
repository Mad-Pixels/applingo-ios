import SwiftUI

/// Defines styling properties for the Settings view.
final class SettingsStyle: ObservableObject {
    
    // MARK: - Properties
    
    let backgroundColor: Color
    let padding: EdgeInsets
    let spacing: CGFloat
    
    // MARK: - Initializer
    
    init(spacing: CGFloat, padding: EdgeInsets, backgroundColor: Color) {
        self.spacing = spacing
        self.padding = padding
        self.backgroundColor = backgroundColor
    }
}

// MARK: - Themed Style Extension

extension SettingsStyle {
    /// Returns a themed style based on the current application theme.
    static func themed(_ theme: AppTheme) -> SettingsStyle {
        SettingsStyle(
            spacing: 24,
            padding: EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16),
            backgroundColor: theme.backgroundPrimary
        )
    }
}
