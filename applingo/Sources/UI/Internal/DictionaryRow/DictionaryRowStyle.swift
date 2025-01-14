import SwiftUI

struct DictionaryRowStyle {
    let titleColor: Color
    let subtitleColor: Color
    let backgroundColor: Color
    let shadowColor: Color
    let titleFont: Font
    let subtitleFont: Font
    let spacing: CGFloat
    let cornerRadius: CGFloat
    let shadowRadius: CGFloat
    
    static func themed(_ theme: AppTheme) -> DictionaryRowStyle {
        DictionaryRowStyle(
            titleColor: theme.textPrimary,
            subtitleColor: theme.textSecondary,
            backgroundColor: theme.backgroundSecondary,
            shadowColor: theme.accentPrimary,
            titleFont: .system(size: 15, weight: .bold),
            subtitleFont: .system(size: 14),
            spacing: 16,
            cornerRadius: 12,
            shadowRadius: 4
        )
    }
}
