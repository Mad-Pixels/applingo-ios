import SwiftUI

struct ButtonNavStyle {
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

extension ButtonNavStyle {
    static func themed(_ theme: AppTheme) -> ButtonNavStyle {
        ButtonNavStyle(
            backgroundColor: theme.backgroundPrimary,
            foregroundColor: theme.textPrimary,
            iconColor: theme.accentPrimary,
            font: .body.bold(),
            iconSize: 60,
            padding: EdgeInsets(top: 16, leading: 24, bottom: 16, trailing: 24),
            height: 70,
            cornerRadius: 16,
            borderColor: theme is DarkTheme ? .white.opacity(0.1) : .clear,
            borderWidth: theme is DarkTheme ? 1 : 0,
            shadowColor: theme.cardBorder
        )
    }
    
    static func asGameSelect(_ gameTheme: GameTheme) -> ButtonNavStyle {
        ButtonNavStyle(
            backgroundColor: gameTheme.main.opacity(0.1),
            foregroundColor: .white,
            iconColor: gameTheme.main,
            font: .title3.bold(),
            iconSize: 75,
            padding: EdgeInsets(top: 16, leading: 24, bottom: 16, trailing: 24),
            height: 80,
            cornerRadius: 20,
            borderColor: gameTheme.dark,
            borderWidth: 2,
            shadowColor: gameTheme.dark.opacity(0.5)
        )
    }
}
