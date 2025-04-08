import SwiftUI

struct FlagIconStyle {
    // Size Properties
    let flagSize: CGFloat
    let codeSize: CGFloat

    // Layout Properties
    let spacing: CGFloat

    // Color Properties
    let borderColor: Color
    let shadowColor: Color
    let codeColor: Color
    let fallbackBackgroundColor: Color
}

extension FlagIconStyle {
    static func themed(_ theme: AppTheme) -> FlagIconStyle {
        FlagIconStyle(
            flagSize: 16,
            codeSize: 11,
            spacing: 10,
            borderColor: theme.textSecondary.opacity(0.2),
            shadowColor: theme.textSecondary,
            codeColor: theme.accentPrimary,
            fallbackBackgroundColor: theme.backgroundPrimary
        )
    }
}
