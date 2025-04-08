import SwiftUI

struct ButtonNavStyle {
    // Icon Properties
    let icon: ButtonNavIcon
    let iconColor: Color
    let iconSize: CGFloat

    // Background Properties
    let backgroundColor: Color
    let activeBackgroundColor: Color

    // Layout Properties
    let size: CGFloat
    let cornerRadius: CGFloat
}

extension ButtonNavStyle {
    static func back(_ theme: AppTheme) -> ButtonNavStyle {
        ButtonNavStyle(
            icon: .system("arrow.backward"),
            iconColor: theme.textPrimary,
            iconSize: 16,
            backgroundColor: theme.backgroundSecondary,
            activeBackgroundColor: theme.backgroundSecondary.opacity(0.8),
            size: 32,
            cornerRadius: 16
        )
    }
    
    static func close(_ theme: AppTheme) -> ButtonNavStyle {
        ButtonNavStyle(
            icon: .system("xmark"),
            iconColor: theme.errorSecondaryColor,
            iconSize: 14,
            backgroundColor: theme.backgroundSecondary,
            activeBackgroundColor: theme.backgroundSecondary.opacity(0.8),
            size: 32,
            cornerRadius: 16
        )
    }
    
    static func edit(_ theme: AppTheme, disabled: Bool = false) -> ButtonNavStyle {
        ButtonNavStyle(
            icon: .system("scribble"),
            iconColor: theme.textPrimary,
            iconSize: 14,
            backgroundColor: theme.backgroundSecondary,
            activeBackgroundColor: theme.backgroundSecondary.opacity(0.8),
            size: 32,
            cornerRadius: 16
        )
    }
    
    static func save(_ theme: AppTheme, disabled: Bool = false) -> ButtonNavStyle {
        ButtonNavStyle(
            icon: .system("checkmark"),
            iconColor: disabled ? theme.success.opacity(0.15) : theme.success,
            iconSize: 14,
            backgroundColor: theme.backgroundSecondary,
            activeBackgroundColor: theme.backgroundSecondary.opacity(0.8),
            size: 32,
            cornerRadius: 16
        )
    }
    
    static func download(_ theme: AppTheme, disabled: Bool = false) -> ButtonNavStyle {
        ButtonNavStyle(
            icon: .system("square.and.arrow.down"),
            iconColor: disabled ? theme.textSecondary.opacity(0.35) : theme.textSecondary,
            iconSize: 14,
            backgroundColor: theme.backgroundSecondary,
            activeBackgroundColor: theme.backgroundSecondary.opacity(0.8),
            size: 32,
            cornerRadius: 16
        )
    }
}
