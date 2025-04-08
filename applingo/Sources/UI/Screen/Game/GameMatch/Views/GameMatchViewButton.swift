import SwiftUI

struct GameMatchViewButton: View {
    @EnvironmentObject private var themeManager: ThemeManager

    let text: String
    let action: () -> Void
    let isSelected: Bool
    let isMatched: Bool
    let highlightColor: Color?

    var body: some View {
        ButtonAction(
            title: text,
            action: action,
            disabled: isMatched,
            style: getButtonStyle()
        )
        .frame(height: 72)
    }

    private func getButtonStyle() -> ButtonActionStyle {
        if let color = highlightColor {
            return .GameAnswer(themeManager.currentThemeStyle, highlightColor: color)
        } else if isMatched {
            return createMatchedStyle()
        } else if isSelected {
            return createSelectedStyle()
        } else {
            return .game(themeManager.currentThemeStyle)
        }
    }

    private func createSelectedStyle() -> ButtonActionStyle {
        var style = ButtonActionStyle.game(themeManager.currentThemeStyle)
        style.backgroundColor = themeManager.currentThemeStyle.accentPrimary.opacity(0.7)
        return style
    }

    private func createMatchedStyle() -> ButtonActionStyle {
        var style = ButtonActionStyle.game(themeManager.currentThemeStyle)
        style.backgroundColor = Color.gray.opacity(0.4)
        return style
    }
}
