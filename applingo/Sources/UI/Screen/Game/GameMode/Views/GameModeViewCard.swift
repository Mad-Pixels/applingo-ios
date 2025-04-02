import SwiftUI

internal struct GameModeViewCard: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    let locale: GameModeLocale
    let style: GameTheme
    let mode: GameModeType
    
    let icon: String
    let title: String
    let description: String
    
    let onSelect: () -> Void
    
    var body: some View {
        ButtonMenu(
            title: title,
            subtitle: description,
            iconType: .system(icon),
            isSelected: false,
            action: onSelect,
            style: .game(themeManager.currentThemeStyle, style)
        )
    }
}
