import SwiftUI

// MARK: - ButtonMenuStyle
/// Defines styling parameters for the ButtonMenu component.
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
    let hStackSpacing: CGFloat
    let iconFrameSize: CGSize
    let transitionType: String
}

extension ButtonMenuStyle {
    /// Returns a themed style based on the provided AppTheme.
    static func themed(_ theme: AppTheme) -> ButtonMenuStyle {
        ButtonMenuStyle(
            backgroundColor: theme.backgroundSecondary,
            foregroundColor: theme.textPrimary,
            iconColor: theme.accentPrimary,
            font: .body.bold(),
            iconSize: 36,
            padding: EdgeInsets(top: 16, leading: 24, bottom: 16, trailing: 24),
            height: 70,
            cornerRadius: 12,
            borderColor: theme is DarkTheme ? Color.white.opacity(0.1) : .clear,
            borderWidth: theme is DarkTheme ? 1 : 0,
            shadowColor: theme.cardBorder,
            hStackSpacing: 16,
            iconFrameSize: CGSize(width: 64, height: 64),
            transitionType: "chevron.up"
        )
    }
    
    /// Returns a style for external links based on the provided AppTheme.
    static func external(_ theme: AppTheme) -> ButtonMenuStyle {
        ButtonMenuStyle(
            backgroundColor: theme.backgroundSecondary,
            foregroundColor: theme.textPrimary,
            iconColor: theme.accentPrimary,
            font: .body.bold(),
            iconSize: 64,
            padding: EdgeInsets(top: 16, leading: 24, bottom: 16, trailing: 24),
            height: 70,
            cornerRadius: 12,
            borderColor: theme is DarkTheme ? Color.white.opacity(0.1) : .clear,
            borderWidth: theme is DarkTheme ? 1 : 0,
            shadowColor: theme.cardBorder,
            hStackSpacing: 16,
            iconFrameSize: CGSize(width: 64, height: 64),
            transitionType: "arrow.up.forward.app"
        )
    }
    
    /// Returns a style for add menus based on the provided AppTheme.
    static func add(_ theme: AppTheme) -> ButtonMenuStyle {
        ButtonMenuStyle(
            backgroundColor: theme.backgroundSecondary,
            foregroundColor: theme.textPrimary,
            iconColor: theme.accentPrimary,
            font: .body.bold(),
            iconSize: 64,
            padding: EdgeInsets(top: 16, leading: 24, bottom: 16, trailing: 24),
            height: 70,
            cornerRadius: 12,
            borderColor: theme is DarkTheme ? Color.white.opacity(0.1) : .clear,
            borderWidth: theme is DarkTheme ? 1 : 0,
            shadowColor: theme.cardBorder,
            hStackSpacing: 16,
            iconFrameSize: CGSize(width: 64, height: 64),
            transitionType: "plus.app"
        )
    }
    
    /// Returns a style for game menus based on the provided AppTheme and GameTheme.
    static func game(_ theme: AppTheme, _ gameTheme: GameTheme) -> ButtonMenuStyle {
        ButtonMenuStyle(
            backgroundColor: theme.backgroundPrimary,
            foregroundColor: theme.textPrimary,
            iconColor: gameTheme.main,
            font: .body.bold(),
            iconSize: 36,
            padding: EdgeInsets(top: 16, leading: 24, bottom: 16, trailing: 24),
            height: 70,
            cornerRadius: 16,
            borderColor: theme is DarkTheme ? Color.white.opacity(0.1) : .clear,
            borderWidth: theme is DarkTheme ? 1 : 0,
            shadowColor: theme.cardBorder,
            hStackSpacing: 16,
            iconFrameSize: CGSize(width: 42, height: 42),
            transitionType: "xw"
        )
    }
}
