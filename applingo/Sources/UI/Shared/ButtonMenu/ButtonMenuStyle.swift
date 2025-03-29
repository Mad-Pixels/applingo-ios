import SwiftUI

struct ButtonMenuStyle {
    // Color Properties
    let backgroundColor: Color
    let foregroundColor: Color
    let iconColor: Color
    let borderColor: Color
    let shadowColor: Color

    // Layout Properties
    let padding: EdgeInsets
    let height: CGFloat
    let cornerRadius: CGFloat
    let borderWidth: CGFloat
    let hStackSpacing: CGFloat
    let iconFrameSize: CGSize

    // Icon Properties
    let iconSize: CGFloat
    let transitionType: String
}

extension ButtonMenuStyle {
    static func themed(_ theme: AppTheme) -> ButtonMenuStyle {
        ButtonMenuStyle(
            backgroundColor: theme.backgroundSecondary,
            foregroundColor: theme.textPrimary,
            iconColor: theme.accentPrimary,
            borderColor: theme is DarkTheme ? Color.white.opacity(0.1) : .clear,
            shadowColor: theme.cardBorder,
            padding: EdgeInsets(top: 16, leading: 24, bottom: 16, trailing: 24),
            height: 70,
            cornerRadius: 12,
            borderWidth: theme is DarkTheme ? 1 : 0,
            hStackSpacing: 16,
            iconFrameSize: CGSize(width: 64, height: 64),
            iconSize: 36,
            transitionType: "chevron.up"
        )
    }

    static func external(_ theme: AppTheme) -> ButtonMenuStyle {
        ButtonMenuStyle(
            backgroundColor: theme.backgroundSecondary,
            foregroundColor: theme.textPrimary,
            iconColor: theme.accentPrimary,
            borderColor: theme is DarkTheme ? Color.white.opacity(0.1) : .clear,
            shadowColor: theme.cardBorder,
            padding: EdgeInsets(top: 16, leading: 24, bottom: 16, trailing: 24),
            height: 70,
            cornerRadius: 12,
            borderWidth: theme is DarkTheme ? 1 : 0,
            hStackSpacing: 16,
            iconFrameSize: CGSize(width: 64, height: 64),
            iconSize: 64,
            transitionType: "arrow.up.forward.app"
        )
    }

    static func add(_ theme: AppTheme) -> ButtonMenuStyle {
        ButtonMenuStyle(
            backgroundColor: theme.backgroundSecondary,
            foregroundColor: theme.textPrimary,
            iconColor: theme.accentPrimary,
            borderColor: theme is DarkTheme ? Color.white.opacity(0.1) : .clear,
            shadowColor: theme.cardBorder,
            padding: EdgeInsets(top: 16, leading: 24, bottom: 16, trailing: 24),
            height: 70,
            cornerRadius: 12,
            borderWidth: theme is DarkTheme ? 1 : 0,
            hStackSpacing: 16,
            iconFrameSize: CGSize(width: 64, height: 64),
            iconSize: 64,
            transitionType: "plus.app"
        )
    }

    static func game(_ theme: AppTheme, _ gameTheme: GameTheme) -> ButtonMenuStyle {
        ButtonMenuStyle(
            backgroundColor: theme.backgroundPrimary,
            foregroundColor: theme.textPrimary,
            iconColor: gameTheme.main,
            borderColor: theme is DarkTheme ? Color.white.opacity(0.1) : .clear,
            shadowColor: theme.cardBorder,
            padding: EdgeInsets(top: 16, leading: 24, bottom: 16, trailing: 24),
            height: 70,
            cornerRadius: 16,
            borderWidth: theme is DarkTheme ? 1 : 0,
            hStackSpacing: 16,
            iconFrameSize: CGSize(width: 42, height: 42),
            iconSize: 36,
            transitionType: ""
        )
    }
}
