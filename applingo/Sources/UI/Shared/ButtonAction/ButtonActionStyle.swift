import SwiftUI

struct ButtonActionStyle {
    let backgroundColor: Color
    let textColor: Color
    let font: Font
    let height: CGFloat
    let cornerRadius: CGFloat
    let padding: EdgeInsets
}

extension ButtonActionStyle {
    static func themed(_ theme: AppTheme) -> ButtonActionStyle {
        return ButtonActionStyle(
            backgroundColor: theme.accentPrimary,
            textColor: theme.accentContrast,
            font: .body.bold(),
            height: 45,
            cornerRadius: 8,
            padding: EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16)
        )
    }
    
    static func action(_ theme: AppTheme) -> ButtonActionStyle {
        return ButtonActionStyle(
            backgroundColor: theme.accentPrimary,
            textColor: theme.textContrast,
            font: .body.bold(),
            height: 45,
            cornerRadius: 8,
            padding: EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16)
        )
    }
    
    static func cancel(_ theme: AppTheme) -> ButtonActionStyle {
        return ButtonActionStyle(
            backgroundColor: theme.errorBackgroundColor,
            textColor: theme.errorPrimaryColor,
            font: .body.bold(),
            height: 45,
            cornerRadius: 8,
            padding: EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16)
        )
    }
}
