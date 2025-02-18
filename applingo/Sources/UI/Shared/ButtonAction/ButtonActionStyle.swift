import SwiftUI

// MARK: - ButtonActionStyle
/// Defines the styling parameters for the ButtonAction component.
struct ButtonActionStyle {
    let pattern: DynamicPatternModel
    let patternBorder: Bool
    let patternBackground: Bool
    let backgroundColor: Color
    let textColor: Color
    let font: Font
    let fontPointSize: CGFloat
    let height: CGFloat
    let cornerRadius: CGFloat
    let borderWidth: CGFloat
    let borderColor: Color
    let padding: EdgeInsets
    let textStyle: DynamicTextStyle
}

extension ButtonActionStyle {
    /// Returns a themed style based on the provided AppTheme.
    static func themed(_ theme: AppTheme) -> ButtonActionStyle {
        ButtonActionStyle(
            pattern: theme.mainPattern,
            patternBorder: false,
            patternBackground: false,
            backgroundColor: theme.accentPrimary,
            textColor: theme.accentContrast,
            font: .body.bold(),
            fontPointSize: 17, // Adjust this value as needed
            height: 45,
            cornerRadius: 8,
            borderWidth: 0,
            borderColor: theme.cardBorder,
            padding: EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16),
            textStyle: .themed(ThemeManager.shared.currentThemeStyle)
        )
    }
    
    /// Returns an action style variant.
    static func action(_ theme: AppTheme) -> ButtonActionStyle {
        ButtonActionStyle(
            pattern: theme.mainPattern,
            patternBorder: false,
            patternBackground: false,
            backgroundColor: theme.accentPrimary,
            textColor: theme.textContrast,
            font: .body.bold(),
            fontPointSize: 17,
            height: 45,
            cornerRadius: 8,
            borderWidth: 0,
            borderColor: theme.cardBorder,
            padding: EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8),
            textStyle: .themed(ThemeManager.shared.currentThemeStyle)
        )
    }
    
    /// Returns a cancel style variant.
    static func cancel(_ theme: AppTheme) -> ButtonActionStyle {
        ButtonActionStyle(
            pattern: theme.mainPattern,
            patternBorder: false,
            patternBackground: false,
            backgroundColor: theme.errorBackgroundColor,
            textColor: theme.errorPrimaryColor,
            font: .body.bold(),
            fontPointSize: 17,
            height: 45,
            cornerRadius: 8,
            borderWidth: 0,
            borderColor: theme.cardBorder,
            padding: EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8),
            textStyle: .themed(ThemeManager.shared.currentThemeStyle)
        )
    }
    
    /// Returns a menu style variant.
    static func menu(_ theme: AppTheme) -> ButtonActionStyle {
        ButtonActionStyle(
            pattern: theme.mainPattern,
            patternBorder: true,
            patternBackground: false,
            backgroundColor: theme.backgroundPrimary,
            textColor: theme.textPrimary,
            font: .body.bold(),
            fontPointSize: 17,
            height: 80,
            cornerRadius: 20,
            borderWidth: 8,
            borderColor: theme.cardBorder,
            padding: EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8),
            textStyle: .titled(ThemeManager.shared.currentThemeStyle)
        )
    }
    
    /// Returns a menu style variant.
    static func gameAnswer(_ theme: AppTheme) -> ButtonActionStyle {
        ButtonActionStyle(
            pattern: theme.mainPattern,
            patternBorder: false,
            patternBackground: false,
            backgroundColor: theme.backgroundSecondary,
            textColor: theme.textPrimary,
            font: .body,
            fontPointSize: 14,
            height: 65,
            cornerRadius: 14,
            borderWidth: 4,
            borderColor: theme.cardBorder,
            padding: EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4),
            textStyle: .gameAnswer(ThemeManager.shared.currentThemeStyle)
        )
    }
}
