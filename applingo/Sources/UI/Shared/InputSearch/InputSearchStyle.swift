import SwiftUI

struct InputSearchStyle {
    let backgroundColor: Color
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
}

extension InputSearchStyle {
    static func themed(_ theme: AppTheme) -> InputSearchStyle {
        InputSearchStyle(
            backgroundColor: theme.backgroundPrimary,
            textColor: theme.textPrimary,
            placeholderColor: theme.textPrimary,
            iconColor: theme.textSecondary,
            padding: EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12),
            cornerRadius: 12,
            iconSize: 20,
            spacing: 8,
            shadowColor: theme.textSecondary.opacity(0.2),
            shadowRadius: 4,
            shadowX: 0,
            shadowY: 2
        )
    }
}
