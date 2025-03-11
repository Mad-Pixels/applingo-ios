import SwiftUI

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
    let mainIconFontSize: CGFloat
    let itemIconFontSize: CGFloat
    let containerPadding: EdgeInsets
}

extension ButtonFloatingStyle {
    /// Default themed button style.
    static func themed(_ theme: AppTheme) -> ButtonFloatingStyle {
        ButtonFloatingStyle(
            mainButtonColor: theme.accentPrimary,
            itemButtonColor: theme.accentPrimary,
            mainButtonSize: CGSize(width: 60, height: 60),
            itemButtonSize: CGSize(width: 50, height: 50),
            spacing: 10,
            cornerRadius: 30,
            shadowColor: theme.backgroundPrimary.opacity(0.3),
            shadowRadius: 5,
            mainIconFontSize: 24,
            itemIconFontSize: 20,
            containerPadding: EdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16)
        )
    }
}
