import SwiftUI

struct WordRowStyle {
    let frontTextColor: Color
    let backTextColor: Color
    let iconColor: Color
    let capsuleColor: Color
    let frontTextFont: Font
    let backTextFont: Font
    let capsuleSize: CGSize
    let spacing: CGFloat
    
    static func themed(_ theme: AppTheme) -> WordRowStyle {
        WordRowStyle(
            frontTextColor: theme.textPrimary,
            backTextColor: theme.textSecondary,
            iconColor: theme.accentPrimary,
            capsuleColor: theme.accentPrimary.opacity(0.1),
            frontTextFont: .system(size: 15, weight: .bold),
            backTextFont: .system(size: 14),
            capsuleSize: CGSize(width: 36, height: 24),
            spacing: 12
        )
    }
}
