import SwiftUI

// MARK: - SectionBodyStyle
/// Defines styling parameters for SectionBody.
struct SectionBodyStyle {
    let backgroundColor: Color
    let shadowColor: Color
    let cornerRadius: CGFloat
    let shadowRadius: CGFloat
    let padding: EdgeInsets
}

extension SectionBodyStyle {
    /// Returns a themed style based on the provided AppTheme.
    static func themed(_ theme: AppTheme) -> SectionBodyStyle {
        SectionBodyStyle(
            backgroundColor: theme.backgroundSecondary,
            shadowColor: theme.accentPrimary,
            cornerRadius: 12,
            shadowRadius: 4,
            padding: EdgeInsets(top: 9, leading: 12, bottom: 9, trailing: 12)
        )
    }
    
    /// Returns a area style based on the provider AppTheme.
    static func area(_ theme: AppTheme) -> SectionBodyStyle {
        SectionBodyStyle(
            backgroundColor: theme.backgroundSecondary.opacity(0.5),
            shadowColor: theme.backgroundSecondary,
            cornerRadius: 8,
            shadowRadius: 0,
            padding: EdgeInsets(top: 9, leading: 12, bottom: 9, trailing: 12)
        )
    }
}
