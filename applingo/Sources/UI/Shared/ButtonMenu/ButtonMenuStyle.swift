import SwiftUI

struct ButtonMenuStyle {
    let backgroundColor: Color
    let foregroundColor: Color
    let iconColor: Color
    let font: Font
    let iconSize: CGFloat
    let padding: EdgeInsets
    let height: CGFloat
    let cornerRadius: CGFloat

    let borderColor: Color
    let borderWidth: CGFloat
    let shadowColor: Color
}

extension ButtonMenuStyle {
    static func themed(_ theme: AppTheme) -> ButtonMenuStyle {
        ButtonMenuStyle(
            backgroundColor: theme.backgroundSecondary,
            foregroundColor: theme.textPrimary,
            iconColor: theme.accentDark,
            font: .body.bold(),
            iconSize: 36,
            padding: EdgeInsets(top: 16, leading: 24, bottom: 16, trailing: 24),
            height: 70,
            cornerRadius: 16,
            borderColor: theme is DarkTheme ? .white.opacity(0.1) : .clear,
            borderWidth: theme is DarkTheme ? 1 : 0,
            shadowColor: theme.cardBorder
        )
    }
    
    static func game(_ theme: AppTheme, _ gameTheme: GameTheme) -> ButtonMenuStyle {
        ButtonMenuStyle(
            backgroundColor: theme.backgroundPrimary,
            foregroundColor: theme.textPrimary,
            iconColor: gameTheme.dark,
            font: .body.bold(),
            iconSize: 36,
            padding: EdgeInsets(top: 16, leading: 24, bottom: 16, trailing: 24),
            height: 70,
            cornerRadius: 16,
            borderColor: theme is DarkTheme ? .white.opacity(0.1) : .clear,
            borderWidth: theme is DarkTheme ? 1 : 0,
            shadowColor: theme.cardBorder
        )
    }
}
