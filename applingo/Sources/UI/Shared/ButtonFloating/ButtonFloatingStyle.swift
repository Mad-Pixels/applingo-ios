import SwiftUI

struct ButtonFloatingStyle {
    // Color Properties
    let mainButtonColor: Color
    let itemButtonColor: Color
    let shadowColor: Color

    // Size Properties
    let mainButtonSize: CGSize
    let itemButtonSize: CGSize
    let cornerRadius: CGFloat

    // Layout Properties
    let spacing: CGFloat

    // Shadow Properties
    let shadowRadius: CGFloat
}

extension ButtonFloatingStyle {
    static func themed(_ theme: AppTheme) -> ButtonFloatingStyle {
        ButtonFloatingStyle(
            mainButtonColor: theme.accentPrimary,
            itemButtonColor: theme.accentPrimary,
            shadowColor: theme.backgroundPrimary.opacity(0.3),
            mainButtonSize: CGSize(width: 60, height: 60),
            itemButtonSize: CGSize(width: 50, height: 50),
            cornerRadius: 30,
            spacing: 10,
            shadowRadius: 5
        )
    }
}
