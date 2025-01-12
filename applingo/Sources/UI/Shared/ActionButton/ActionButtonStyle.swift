import SwiftUI

struct ActionButtonStyle {
    let backgroundColor: Color
    let textColor: Color
    let font: Font
    let height: CGFloat
    let cornerRadius: CGFloat
    let padding: EdgeInsets
}

extension ActionButtonStyle {
    static func themed(_ theme: AppTheme, type: ActionButton.ButtonType) -> ActionButtonStyle {
        switch type {
        case .action:
            return ActionButtonStyle(
                backgroundColor: theme.accentPrimary,
                textColor: theme.textPrimary,
                font: .body.bold(),
                height: 45,
                cornerRadius: 8,
                padding: EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16)
            )
        case .cancel:
            return ActionButtonStyle(
                backgroundColor: theme.backgroundSecondary,
                textColor: theme.textPrimary,
                font: .body.bold(),
                height: 45,
                cornerRadius: 8,
                padding: EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16)
            )
        }
    }
}
