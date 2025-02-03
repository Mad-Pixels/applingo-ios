import SwiftUI

// MARK: - FlagIconStyle
/// Defines styling parameters for the FlagIcon component.
struct FlagIconStyle {
    let flagSize: CGFloat
    let codeSize: CGFloat
    let spacing: CGFloat
    let borderColor: Color
    let shadowColor: Color
    let codeColor: Color
    let fallbackBackgroundColor: Color
    
    /// Returns a themed style based on the provided AppTheme.
    static func themed(_ theme: AppTheme) -> FlagIconStyle {
        FlagIconStyle(
            flagSize: 16,
            codeSize: 11,
            spacing: 10,
            borderColor: theme.textSecondary.opacity(0.2),
            shadowColor: theme.textSecondary,
            codeColor: theme.accentPrimary,
            fallbackBackgroundColor: theme.backgroundPrimary
        )
    }
}
