import SwiftUI

struct WordRowStyle {
    let frontTextColor: Color
    let backTextColor: Color
    let arrowColor: Color
    let capsuleColor: Color
    let frontTextFont: Font
    let backTextFont: Font
    let arrowSize: CGFloat
    let capsuleSize: CGSize
    
    let spacing: CGFloat
    let backgroundColor: Color
    let cornerRadius: CGFloat
    let shadowRadius: CGFloat
    
    static func themed(_ theme: AppTheme) -> WordRowStyle {
        WordRowStyle(
            frontTextColor: theme.textPrimary,
            backTextColor: theme.textSecondary,
            arrowColor: theme.accentPrimary,
            capsuleColor: theme.accentPrimary.opacity(0.1),
            frontTextFont: .system(size: 15, weight: .bold),
            backTextFont: .system(size: 14),
            arrowSize: 14,
            capsuleSize: CGSize(width: 36, height: 24),
            spacing: 12,
            backgroundColor: theme.backgroundSecondary,
            cornerRadius: 12,
            shadowRadius: 4
        )
    }
}
