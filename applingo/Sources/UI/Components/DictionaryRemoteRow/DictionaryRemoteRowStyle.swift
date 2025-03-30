import SwiftUI

struct DictionaryRemoteRowStyle {
    let titleColor: Color
    let accentColor: Color
    let subtitleColor: Color
    let titleFont: Font
    let subtitleFont: Font
    let wordCountFont: Font
    let spacing: CGFloat
    
    static func themed(_ theme: AppTheme) -> DictionaryRemoteRowStyle {
        DictionaryRemoteRowStyle(
            titleColor: theme.textPrimary,
            accentColor: theme.accentPrimary,
            subtitleColor: theme.textSecondary,
            titleFont: .system(size: 15, weight: .bold),
            subtitleFont: .system(size: 14),
            wordCountFont: .system(size: 12, weight: .medium),
            spacing: 12
        )
    }
}
