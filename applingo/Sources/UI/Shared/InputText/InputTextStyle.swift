import SwiftUI

struct InputTextStyle {
    let textColor: Color
    let placeholderColor: Color
    let backgroundColor: Color
    let borderColor: Color
    let disabledBorderColor: Color
    let iconColor: Color
    let font: Font
    let padding: EdgeInsets
    let cornerRadius: CGFloat
    let borderWidth: CGFloat
}

extension InputTextStyle {
    static func themed(_ theme: AppTheme) -> InputTextStyle {
        InputTextStyle(
            textColor: theme.textPrimary,
            placeholderColor: theme.textPrimary.opacity(0.5),
            backgroundColor: theme.backgroundPrimary,
            borderColor: theme.accentLight,
            disabledBorderColor: theme.backgroundPrimary,
            iconColor: theme.textSecondary,
            font: .body,
            padding: EdgeInsets(top: 14, leading: 12, bottom: 14, trailing: 12),
            cornerRadius: 8,
            borderWidth: 2
        )
    }
}
