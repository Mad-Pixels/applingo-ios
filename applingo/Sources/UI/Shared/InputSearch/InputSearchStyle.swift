import SwiftUI

struct InputSearchStyle {
    // Colors (Active State)
    let borderColor: Color
    let accentColor: Color
    let textColor: Color
    let placeholderColor: Color
    let iconColor: Color

    // Colors (Disabled State)
    let disabledBorderColor: Color
    let disabledTextColor: Color
    let disabledIconColor: Color
    let disabledBackgroundColor: Color

    // Layout & Appearance
    let padding: EdgeInsets
    let cornerRadius: CGFloat
    let iconSize: CGFloat
    let spacing: CGFloat

    // Shadow Properties
    let shadowColor: Color
    let shadowRadius: CGFloat
    let shadowX: CGFloat
    let shadowY: CGFloat
}

extension InputSearchStyle {
    static func themed(_ theme: AppTheme) -> InputSearchStyle {
        InputSearchStyle(
            borderColor: theme.accentContrast,
            accentColor: theme.accentPrimary,
            textColor: theme.textPrimary,
            placeholderColor: theme.textPrimary,
            iconColor: theme.accentContrast,
            disabledBorderColor: theme.textSecondary,
            disabledTextColor: theme.textSecondary,
            disabledIconColor: theme.textSecondary,
            disabledBackgroundColor: theme.backgroundSecondary,
            padding: EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12),
            cornerRadius: 24,
            iconSize: 20,
            spacing: 8,
            shadowColor: theme.textSecondary.opacity(0.2),
            shadowRadius: 4,
            shadowX: 0,
            shadowY: 2
        )
    }
}
