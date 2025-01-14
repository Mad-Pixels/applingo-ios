import SwiftUI

struct FlagIconStyle {
    let flagSize: CGFloat
    let codeSize: CGFloat
    let spacing: CGFloat
    let borderColor: Color
    let shadowColor: Color
    let codeColor: Color
    let fallbackBackgroundColor: Color
    
    static func themed(_ theme: AppTheme) -> FlagIconStyle {
        FlagIconStyle(
            flagSize: 16,
            codeSize: 10,
            spacing: 8,
            borderColor: theme.textSecondary.opacity(0.2),
            shadowColor: theme.textSecondary,
            codeColor: theme.textSecondary,
            fallbackBackgroundColor: theme.backgroundSecondary
        )
    }
}
