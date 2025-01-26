import SwiftUI

struct SectionHeaderStyle {
    let titleColor: Color
    let separatorColor: Color
    let titleFont: Font
    let spacing: CGFloat
    let padding: EdgeInsets
    
    static func themed(_ theme: AppTheme) -> SectionHeaderStyle {
        SectionHeaderStyle(
            titleColor: theme.textSecondary,
            separatorColor: theme.textSecondary.opacity(0.15),
            titleFont: .system(size: 13, weight: .semibold),
            spacing: 8,
            padding: EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        )
    }
    
    static func titled(_ theme: AppTheme) -> SectionHeaderStyle {
        SectionHeaderStyle(
            titleColor: theme.accentPrimary,
            separatorColor: theme.textSecondary.opacity(0.15),
            titleFont: .system(size: 16, weight: .bold),
            spacing: 8,
            padding: EdgeInsets(top: 0, leading: 16, bottom: 10, trailing: 16)
        )
    }
    
    static func heading(_ theme: AppTheme) -> SectionHeaderStyle {
       SectionHeaderStyle(
            titleColor: theme.textPrimary,
            separatorColor: theme.textSecondary.opacity(0),
            titleFont: .system(size: 18, weight: .bold),
            spacing: 0,
            padding: EdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 0)
        )
    }
}
