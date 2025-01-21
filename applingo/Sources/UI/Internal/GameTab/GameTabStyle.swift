import SwiftUI

struct GameTabStyle {
    let textPrimaryColor: Color
    let textSecondaryColor: Color
    let accentColor: Color
    let dividerColor: Color
    
    let titleFont: Font
    let valueFont: Font
    let timerFont: Font
    
    let spacing: CGFloat
    let padding: CGFloat
    let dividerHeight: CGFloat
    let iconSize: CGFloat
    
    static func themed(_ theme: AppTheme) -> GameTabStyle {
        GameTabStyle(
            textPrimaryColor: theme.textPrimary,
            textSecondaryColor: theme.textSecondary,
            accentColor: theme.accentPrimary,
            dividerColor: theme.textSecondary.opacity(0.2),
            
            titleFont: .system(size: 12, weight: .medium),
            valueFont: .system(size: 16, weight: .bold),
            timerFont: .system(size: 18, weight: .heavy),
            
            spacing: 16,
            padding: 16,
            dividerHeight: 24,
            iconSize: 16
        )
    }
}
