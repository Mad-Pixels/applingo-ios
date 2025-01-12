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
    static func themed(_ theme: AppTheme, type: ButtonAction.ButtonType) -> ButtonActionStyle {
        switch type {
        case .action:
            return ButtonActionStyle(
                backgroundColor: theme.accentDark,
                textColor: theme.accentContrast,
                font: .body.bold(),
                height: 45,
                cornerRadius: 8,
                padding: EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16)
            )
        case .cancel:
            return ButtonActionStyle(
                backgroundColor: theme.errorBackgroundColor,
                textColor: theme.errorPrimaryColor,
                font: .body.bold(),
                height: 45,
                cornerRadius: 8,
                padding: EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16)
            )
        case .disabled:
            return ButtonActionStyle(
                backgroundColor: theme.backgroundSecondary,
                textColor: theme.textSecondary,
                font: .body.bold(),
                height: 45,
                cornerRadius: 8,
                padding: EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16)
            )
        }
    }
}
