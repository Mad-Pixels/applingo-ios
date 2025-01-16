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
}
