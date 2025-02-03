import SwiftUI

// MARK: - ItemToggleStyle
/// Defines the styling parameters for ItemToggle.
struct ItemToggleStyle {
    let titleColor: Color
    let tintColor: Color
    let spacing: CGFloat
    let showHeader: Bool
}

extension ItemToggleStyle {
    /// Returns a themed style based on the provided AppTheme.
    static func themed(_ theme: AppTheme) -> ItemToggleStyle {
        ItemToggleStyle(
            titleColor: theme.textPrimary,
            tintColor: theme.accentPrimary,
            spacing: 8,
            showHeader: true
        )
    }
}
