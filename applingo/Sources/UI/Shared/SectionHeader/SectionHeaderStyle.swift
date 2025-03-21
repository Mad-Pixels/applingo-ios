import SwiftUI

// MARK: - SectionHeaderStyle
/// Defines the styling parameters for a section header.
struct SectionHeaderStyle {
    let titleColor: Color
    let separatorColor: Color
    let titleFont: Font
    let spacing: CGFloat
    let padding: EdgeInsets
}

extension SectionHeaderStyle {
    /// Themed style based on the given theme.
    static func themed(_ theme: AppTheme) -> SectionHeaderStyle {
        SectionHeaderStyle(
            titleColor: theme.textSecondary,
            separatorColor: theme.textSecondary.opacity(0.15),
            titleFont: .system(size: 13, weight: .semibold),
            spacing: 8,
            padding: EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        )
    }
    
    /// Titled style with a bolder appearance.
    static func titled(_ theme: AppTheme) -> SectionHeaderStyle {
        SectionHeaderStyle(
            titleColor: theme.accentPrimary,
            separatorColor: theme.textSecondary.opacity(0.15),
            titleFont: .system(size: 16, weight: .bold),
            spacing: 8,
            padding: EdgeInsets(top: 0, leading: 16, bottom: 10, trailing: 16)
        )
    }
    
    /// Heading style for larger headers.
    static func heading(_ theme: AppTheme) -> SectionHeaderStyle {
        SectionHeaderStyle(
            titleColor: theme.textPrimary,
            separatorColor: theme.textSecondary.opacity(0),
            titleFont: .system(size: 24, weight: .bold),
            spacing: 0,
            padding: EdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 0)
        )
    }
}
