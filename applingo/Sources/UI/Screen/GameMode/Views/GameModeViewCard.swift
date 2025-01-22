import SwiftUI

struct GameModeViewCard: View {
   let mode: GameModeType
   let icon: String
   let title: String
   let description: String
    let style: GameTheme
   let isSelected: Bool
   let onSelect: () -> Void
   @EnvironmentObject private var themeManager: ThemeManager
   
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
