import SwiftUI

struct ButtonIconStyle {
    let pattern: DynamicPatternModel
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

extension ButtonIconStyle {
    static func themed(_ theme: AppTheme) -> ButtonIconStyle {
        ButtonIconStyle(
            pattern: theme.mainPattern,
            backgroundColor: theme.backgroundPrimary,
            foregroundColor: theme.textPrimary,
            iconColor: theme.cardBorder,
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

    static func asGameSelect(_ theme: AppTheme, _ gameTheme: GameTheme) -> ButtonIconStyle {
        ButtonIconStyle(
            pattern: theme.mainPattern,
            backgroundColor: gameTheme.main.opacity(0.1),
            foregroundColor: .white,
            iconColor: gameTheme.main,
            font: .title3.bold(),
            iconSize: 60,
            iconRotation: 0,
            padding: EdgeInsets(top: 16, leading: 24, bottom: 16, trailing: 24),
            height: 80,
            cornerRadius: 20,
            borderColor: gameTheme.dark,
            borderWidth: 2,
            highlightOnPress: true
        )
    }
}
