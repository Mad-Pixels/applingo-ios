import SwiftUI

// MARK: - SectionBodyStyle
/// Defines styling parameters for SectionBody.
struct SectionBodyStyle {
    let backgroundColor: Color
    let shadowColor: Color
    let cornerRadius: CGFloat
    let shadowRadius: CGFloat
    let padding: EdgeInsets

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
}
