import SwiftUI

struct GameModeViewCard: View {
   let mode: GameModeEnum
   let icon: String
   let title: String
   let description: String
   let style: GameModeStyle
   let isSelected: Bool
   let onSelect: () -> Void
   @EnvironmentObject private var themeManager: ThemeManager
   
    var body: some View {
        ButtonMenu(
            title: title,
            subtitle: description,
            icon: icon,
            isSelected: true,
            style: .themed(themeManager.currentThemeStyle),
            action: onSelect
        )
    }
}
