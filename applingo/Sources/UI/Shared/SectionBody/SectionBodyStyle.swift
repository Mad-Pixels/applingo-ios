import SwiftUI

struct SectionBodyStyle {
    // Appearance Properties
    let backgroundColor: Color
    let cornerRadius: CGFloat
    let borderWidth: CGFloat?
    let borderColor: Color?
    
    // Shadow Properties
    let shadowColor: Color
    let shadowRadius: CGFloat
    
    // Layout Properties
    let padding: EdgeInsets
}

extension SectionBodyStyle {
    static func block(_ theme: AppTheme) -> SectionBodyStyle {
        SectionBodyStyle(
            backgroundColor: theme.backgroundSecondary,
            cornerRadius: 12,
            borderWidth: nil,
            borderColor: nil,
            shadowColor: theme.backgroundSecondary,
            shadowRadius: 4,
            padding: EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12)
        )
    }
    
    static func accent(_ theme: AppTheme) -> SectionBodyStyle {
        SectionBodyStyle(
            backgroundColor: theme.accentLight.opacity(0.1),
            cornerRadius: 12,
            borderWidth: 1,
            borderColor: theme.accentPrimary,
            shadowColor: theme.backgroundSecondary,
            shadowRadius: 0,
            padding: EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12)
        )
    }
}
