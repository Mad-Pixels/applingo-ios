import SwiftUI

struct FloatingButtonStyle {
    let mainButtonColor: Color
    let itemButtonColor: Color
    let mainButtonSize: CGSize
    let itemButtonSize: CGSize
    let spacing: CGFloat
    let cornerRadius: CGFloat
    let shadowColor: Color
    let shadowRadius: CGFloat
}

extension FloatingButtonStyle {
    static func themed(_ theme: AppTheme) -> FloatingButtonStyle {
        FloatingButtonStyle(
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
