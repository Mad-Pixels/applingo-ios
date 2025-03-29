import SwiftUI

struct InputTextStyle {
    // Color Properties
    let textColor: Color
    let titleColor: Color
    let placeholderColor: Color
    let backgroundColor: Color
    let disabledBackgroundColor: Color
    let borderColor: Color
    let iconColor: Color

    // Font Properties
    let titleFont: Font
    let textFont: Font

    // Layout & Spacing Properties
    let padding: EdgeInsets
    let cornerRadius: CGFloat
    let iconSpacing: CGFloat
    let titleSpacing: CGFloat
}

extension InputTextStyle {
    static func themed(_ theme: AppTheme) -> InputTextStyle {
        InputTextStyle(
            textColor: theme.textPrimary,
            titleColor: theme.textPrimary,
            placeholderColor: theme.textSecondary,
            backgroundColor: .clear,
            disabledBackgroundColor: theme.backgroundSecondary.opacity(0.5),
            borderColor: theme.accentDark.opacity(0.5),
            iconColor: theme.textSecondary,
            titleFont: .system(size: 15, weight: .bold),
            textFont: .system(size: 14),
            padding: EdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12),
            cornerRadius: 8,
            iconSpacing: 8,
            titleSpacing: 8
        )
    }
}
