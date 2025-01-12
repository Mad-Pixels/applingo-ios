import SwiftUI

struct GameButtonStyle {
    let backgroundColor: Color
    let foregroundColor: Color
    let iconColor: Color
    let font: Font
    let iconSize: CGFloat
    let iconRotation: Double
    let padding: EdgeInsets
    let height: CGFloat
    let cornerRadius: CGFloat

    let borderColor: Color
    let borderWidth: CGFloat
    let highlightOnPress: Bool
}

extension GameButtonStyle {
    static func themed(_ theme: AppTheme, color: Color) -> GameButtonStyle {
        GameButtonStyle(
            backgroundColor: theme.backgroundPrimary,
            foregroundColor: theme.textPrimary,
            iconColor: color,
            font: .body.bold(),
            iconSize: 75,
            iconRotation: 45,
            padding: EdgeInsets(top: 12, leading: 20, bottom: 12, trailing: 20),
            height: 70,
            cornerRadius: 16,
            borderColor: theme is DarkTheme ? .white.opacity(0.1) : .clear,
            borderWidth: theme is DarkTheme ? 1 : 0,
            highlightOnPress: true
        )
    }
}
