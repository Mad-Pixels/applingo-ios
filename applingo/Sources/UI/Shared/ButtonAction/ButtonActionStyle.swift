import SwiftUI

struct ButtonActionStyle {
    let pattern: DynamicPatternModel
    let patternBorder: Bool
    let patternBackground: Bool
    let backgroundColor: Color
    let textColor: Color
    let font: Font
    let height: CGFloat
    let cornerRadius: CGFloat
    let borderWidth: CGFloat
    let borderColor: Color
    let padding: EdgeInsets
}

extension ButtonActionStyle {
    static func themed(_ theme: AppTheme) -> ButtonActionStyle {
        return ButtonActionStyle(
            pattern: theme.mainPattern,
            patternBorder: false,
            patternBackground: false,
            backgroundColor: theme.accentPrimary,
            textColor: theme.accentContrast,
            font: .body.bold(),
            height: 45,
            cornerRadius: 8,
            borderWidth: 0,
            borderColor: theme.cardBorder,
            padding: EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16)
        )
    }
    
    static func action(_ theme: AppTheme) -> ButtonActionStyle {
        return ButtonActionStyle(
            pattern: theme.mainPattern,
            patternBorder: false,
            patternBackground: false,
            backgroundColor: theme.accentPrimary,
            textColor: theme.textContrast,
            font: .body.bold(),
            height: 45,
            cornerRadius: 8,
            borderWidth: 0,
            borderColor: theme.cardBorder,
            padding: EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        )
    }
    
    static func cancel(_ theme: AppTheme) -> ButtonActionStyle {
        return ButtonActionStyle(
            pattern: theme.mainPattern,
            patternBorder: false,
            patternBackground: false,
            backgroundColor: theme.errorBackgroundColor,
            textColor: theme.errorPrimaryColor,
            font: .body.bold(),
            height: 45,
            cornerRadius: 8,
            borderWidth: 0,
            borderColor: theme.cardBorder,
            padding: EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        )
    }
    
    static func menu(_ theme: AppTheme) -> ButtonActionStyle {
        ButtonActionStyle(
            pattern: theme.mainPattern,
            patternBorder: true,
            patternBackground: false,
            backgroundColor: theme.textPrimary,
            textColor: theme.textPrimary,
            font: .body.bold(),
            height: 80,
            cornerRadius: 20,
            borderWidth: 8,
            borderColor: theme.cardBorder,
            padding: EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        )
    }
}
