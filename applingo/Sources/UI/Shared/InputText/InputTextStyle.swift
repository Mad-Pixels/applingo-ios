import SwiftUI

// MARK: - InputTextStyle
/// Defines styling parameters for text input components.
struct InputTextStyle {
    let textColor: Color
    let titleColor: Color
    let placeholderColor: Color
    let backgroundColor: Color
    let disabledBackgroundColor: Color
    let borderColor: Color
    let iconColor: Color
    let titleFont: Font
    let textFont: Font
    let padding: EdgeInsets
    let cornerRadius: CGFloat
    let iconSpacing: CGFloat
    let titleSpacing: CGFloat
    
    /// Returns a themed style based on the provided AppTheme.
    static func themed(_ theme: AppTheme) -> InputTextStyle {
        InputTextStyle(
            textColor: theme.textPrimary,
            titleColor: theme.textPrimary,
            placeholderColor: theme.textSecondary,
            backgroundColor: .clear,
            disabledBackgroundColor: theme.backgroundSecondary.opacity(0.5),
            borderColor: theme.accentPrimary,
            iconColor: theme.textSecondary,
            titleFont: .system(size: 15, weight: .bold),
            textFont: .system(size: 14),
            padding: EdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12),
            cornerRadius: 8,
            iconSpacing: 8,
            titleSpacing: 8
        )
    }
}
