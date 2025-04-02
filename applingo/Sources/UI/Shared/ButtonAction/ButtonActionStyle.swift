import SwiftUI

struct ButtonActionStyle {
    // Pattern Properties
    let pattern: DynamicPatternModel
    let patternBorder: Bool
    let patternBackground: Bool

    // Color Properties
    var backgroundColor: Color
    let borderColor: Color

    // Layout Properties
    let height: CGFloat
    let cornerRadius: CGFloat
    let borderWidth: CGFloat
    let padding: EdgeInsets

    // Text Styling
    let textStyle: (AppTheme) -> DynamicTextStyle
}

extension ButtonActionStyle {
    static func action(_ theme: AppTheme) -> ButtonActionStyle {
        ButtonActionStyle(
            pattern: theme.mainPattern,
            patternBorder: false,
            patternBackground: false,
            backgroundColor: theme.accentPrimary,
            borderColor: theme.cardBorder,
            height: 45,
            cornerRadius: 8,
            borderWidth: 0,
            padding: EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8),
            textStyle: { theme in
                .button(
                    theme,
                    alignment: .center,
                    lineLimit: 1
                )
            }
        )
    }
    
    static func cancel(_ theme: AppTheme) -> ButtonActionStyle {
        ButtonActionStyle(
            pattern: theme.mainPattern,
            patternBorder: false,
            patternBackground: false,
            backgroundColor: theme.errorBackgroundColor,
            borderColor: theme.cardBorder,
            height: 45,
            cornerRadius: 8,
            borderWidth: 0,
            padding: EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8),
            textStyle: { theme in
                .button(
                    theme,
                    alignment: .center,
                    lineLimit: 1
                )
            }
        )
    }
    
    static func menu(_ theme: AppTheme) -> ButtonActionStyle {
        ButtonActionStyle(
            pattern: theme.mainPattern,
            patternBorder: true,
            patternBackground: false,
            backgroundColor: theme.backgroundPrimary,
            borderColor: theme.cardBorder,
            height: 80,
            cornerRadius: 20,
            borderWidth: 8,
            padding: EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8),
            textStyle: { theme in
                .textGameBold(
                    theme,
                    alignment: .center,
                    lineLimit: 1
                )
            }
        )
    }
    
    static func game(_ theme: AppTheme) -> ButtonActionStyle {
        ButtonActionStyle(
            pattern: theme.mainPattern,
            patternBorder: false,
            patternBackground: false,
            backgroundColor: theme.backgroundSecondary,
            borderColor: theme.cardBorder,
            height: 65,
            cornerRadius: 14,
            borderWidth: 4,
            padding: EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4),
            textStyle: { theme in
                .textGame(
                    theme,
                    alignment: .center,
                    lineLimit: 4
                )
            }
        )
    }
    
    static func gameCompact(_ theme: AppTheme) -> ButtonActionStyle {
        ButtonActionStyle(
            pattern: theme.mainPattern,
            patternBorder: false,
            patternBackground: false,
            backgroundColor: theme.backgroundSecondary,
            borderColor: theme.cardBorder,
            height: 65,
            cornerRadius: 14,
            borderWidth: 4,
            padding: EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4),
            textStyle: { theme in
                .textGameCompact(
                    theme,
                    alignment: .center,
                    lineLimit: 3
                )
            }
        )
    }
}
