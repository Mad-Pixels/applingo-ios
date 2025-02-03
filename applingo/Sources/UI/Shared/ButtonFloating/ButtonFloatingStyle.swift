import SwiftUI

// MARK: - ButtonFloatingStyle
/// Defines styling parameters for floating buttons.
struct ButtonFloatingStyle {
    let mainButtonColor: Color
    let itemButtonColor: Color
    let mainButtonSize: CGSize
    let itemButtonSize: CGSize
    let spacing: CGFloat
    let cornerRadius: CGFloat
    let shadowColor: Color
    let shadowRadius: CGFloat
}

extension ButtonFloatingStyle {
    /// Returns a themed style based on the provided AppTheme.
    static func themed(_ theme: AppTheme) -> ButtonFloatingStyle {
        ButtonFloatingStyle(
            mainButtonColor: theme.accentPrimary,
            itemButtonColor: theme.accentPrimary,
            mainButtonSize: CGSize(width: 60, height: 60),
            itemButtonSize: CGSize(width: 50, height: 50),
            spacing: 10,
            cornerRadius: 30,
            shadowColor: theme.backgroundPrimary.opacity(0.3),
            shadowRadius: 5
        )
    }
}
