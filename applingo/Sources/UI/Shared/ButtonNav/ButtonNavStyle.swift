import SwiftUI

struct ButtonNavStyle {
    let icon: String
    let backgroundColor: Color
    let activeBackgroundColor: Color
    let iconColor: Color
    let size: CGFloat
    let cornerRadius: CGFloat
    let iconSize: CGFloat
    
    static func back(_ theme: AppTheme) -> ButtonNavStyle {
        ButtonNavStyle(
            icon: "arrow.backward",
            backgroundColor: theme.backgroundSecondary,
            activeBackgroundColor: theme.backgroundSecondary.opacity(0.8),
            iconColor: theme.textPrimary,
            size: 32,
            cornerRadius: 16,
            iconSize: 16
        )
    }
    
    static func close(_ theme: AppTheme) -> ButtonNavStyle {
        ButtonNavStyle(
            icon: "xmark",
            backgroundColor: theme.backgroundSecondary,
            activeBackgroundColor: theme.backgroundSecondary.opacity(0.8),
            iconColor: theme.errorSecondaryColor,
            size: 32,
            cornerRadius: 16,
            iconSize: 14
        )
    }
    
    static func edit(_ theme: AppTheme, disabled: Bool = false) -> ButtonNavStyle {
        ButtonNavStyle(
            icon: "scribble",
            backgroundColor: theme.backgroundSecondary,
            activeBackgroundColor: theme.backgroundSecondary.opacity(0.8),
            iconColor: theme.textPrimary,
            size: 32,
            cornerRadius: 16,
            iconSize: 14
        )
    }
    
    static func save(_ theme: AppTheme, disabled: Bool = false) -> ButtonNavStyle {
        ButtonNavStyle(
            icon: "checkmark",
            backgroundColor: theme.backgroundSecondary,
            activeBackgroundColor: theme.backgroundSecondary.opacity(0.8),
            iconColor: disabled ? theme.success.opacity(0.35) : theme.success,
            size: 32,
            cornerRadius: 16,
            iconSize: 14
        )
    }
    
    static func download(_ theme: AppTheme, disabled: Bool = false) -> ButtonNavStyle {
        ButtonNavStyle(
            icon: "square.and.arrow.down",
            backgroundColor: theme.backgroundSecondary,
            activeBackgroundColor: theme.backgroundSecondary.opacity(0.8),
            iconColor: disabled ? theme.textSecondary.opacity(0.35) : theme.textSecondary,
            size: 32,
            cornerRadius: 16,
            iconSize: 14
        )
    }
    
    static func downloadLg(_ theme: AppTheme, disabled: Bool = false) -> ButtonNavStyle {
        ButtonNavStyle(
            icon: "square.and.arrow.down",
            backgroundColor: theme.backgroundSecondary,
            activeBackgroundColor: theme.backgroundSecondary.opacity(0.8),
            iconColor: disabled ? theme.textSecondary.opacity(0.35) : theme.textSecondary,
            size: 36,
            cornerRadius: 0,
            iconSize: 20
        )
    }
}
