import SwiftUI

struct GameModeViewCard: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    let mode: GameModeType
    let icon: String
    let title: String
    let description: String
    let style: GameTheme
    let isSelected: Bool
    let onSelect: () -> Void
    
    var body: some View {
        ButtonMenu(
            title: title,
            subtitle: description,
            icon: icon,
            isSelected: true,
            style: .game(themeManager.currentThemeStyle, style),
            action: onSelect
        )
    }
}
