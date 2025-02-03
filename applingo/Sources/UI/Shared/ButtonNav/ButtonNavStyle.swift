import SwiftUI

// MARK: - ButtonNavStyle
/// Defines styling parameters for ButtonNav components.
struct ButtonNavStyle {
    let icon: String
    let backgroundColor: Color
    let activeBackgroundColor: Color
    let iconColor: Color
    let size: CGFloat
    let cornerRadius: CGFloat
    let iconSize: CGFloat
    
    /// Returns a style for a "back" button.
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
    
    /// Returns a style for a "close" button.
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
    
    /// Returns a style for an "edit" button.
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
    
    /// Returns a style for a "save" button.
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
    
    /// Returns a style for a "download" button.
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
    
    /// Returns a larger style for a "download" button.
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
