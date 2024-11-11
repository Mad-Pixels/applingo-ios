import SwiftUI

struct GameMenuButtonStyle: ButtonStyle {
    @ObservedObject private var themeManager = ThemeManager.shared
    
    func makeBody(configuration: Configuration) -> some View {
        let theme = themeManager.currentThemeStyle

        configuration.label
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .fill(theme.accentColor.opacity(0.3))
            }
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(theme.accentColor.opacity(0.7), lineWidth: 1.5)
            )
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}
