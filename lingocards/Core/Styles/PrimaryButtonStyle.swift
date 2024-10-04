import SwiftUI

/// Кастомный стиль кнопки, который использует цвета и шрифты текущей темы.
struct PrimaryButtonStyle: ButtonStyle {
    @EnvironmentObject var themeManager: ThemeManager

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxWidth: .infinity)
            .background(themeManager.currentTheme.accentColor) // Используем основной цвет темы
            .foregroundColor(themeManager.currentTheme.textColor) // Используем цвет текста из темы
            .cornerRadius(10)
            .opacity(configuration.isPressed ? 0.8 : 1.0) // Изменение прозрачности при нажатии
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0) // Легкое уменьшение кнопки при нажатии
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed) // Анимация нажатия
    }
}
