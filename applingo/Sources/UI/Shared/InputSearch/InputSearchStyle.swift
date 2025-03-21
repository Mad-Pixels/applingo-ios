import SwiftUI

// MARK: - InputSearchStyle
/// Defines the styling parameters for the InputSearch component.
struct InputSearchStyle {
    let borderColor: Color
    let accentColor: Color
    let textColor: Color
    let placeholderColor: Color
    let iconColor: Color
    let padding: EdgeInsets
    let cornerRadius: CGFloat
    let iconSize: CGFloat
    let spacing: CGFloat
    let shadowColor: Color
    let shadowRadius: CGFloat
    let shadowX: CGFloat
    let shadowY: CGFloat
    
    
    let disabledBorderColor: Color
    let disabledTextColor: Color
    let disabledIconColor: Color
    let disabledBackgroundColor: Color
}

extension InputSearchStyle {
    /// Returns a themed style based on the provided AppTheme.
    static func themed(_ theme: AppTheme) -> InputSearchStyle {
        InputSearchStyle(
            borderColor: theme.accentContrast,
            accentColor: theme.accentPrimary,
            textColor: theme.textPrimary,
            placeholderColor: theme.textPrimary,
            iconColor: theme.accentContrast,
            padding: EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12),
            cornerRadius: 24,
            iconSize: 20,
            spacing: 8,
            shadowColor: theme.textSecondary.opacity(0.2),
            shadowRadius: 4,
            shadowX: 0,
            shadowY: 2,
            disabledBorderColor: theme.textSecondary,
            disabledTextColor: theme.textSecondary,
            disabledIconColor: theme.textSecondary,
            disabledBackgroundColor: theme.backgroundSecondary
        )
    }
}
