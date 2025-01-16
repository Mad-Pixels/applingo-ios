import SwiftUI

struct InputTextStyle {
    let textColor: Color
    let titleColor: Color
    let placeholderColor: Color
    let backgroundColor: Color
    let disabledBackgroundColor: Color
    let borderColor: Color
    let iconColor: Color
    let titleFont: Font
    let textFont: Font
    let padding: EdgeInsets
    let cornerRadius: CGFloat
    let iconSpacing: CGFloat
    let titleSpacing: CGFloat
    
    static func themed(_ theme: AppTheme) -> InputTextStyle {
        InputTextStyle(
            textColor: theme.textPrimary,
            titleColor: theme.textSecondary,
            placeholderColor: theme.textSecondary,
            backgroundColor: .clear,
            disabledBackgroundColor: theme.backgroundSecondary.opacity(0.5),
            borderColor: theme.accentPrimary,
            iconColor: theme.textSecondary,
            titleFont: .system(size: 13, weight: .semibold),
            textFont: .system(size: 15),
            padding: EdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12),
            cornerRadius: 8,
            iconSpacing: 8,
            titleSpacing: 8
        )
    }
}
