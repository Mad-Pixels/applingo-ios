import SwiftUI

/// A view that represents a single game mode card in the selection list.
struct GameModeViewCard: View {
    // MARK: - Properties
    @EnvironmentObject private var themeManager: ThemeManager
    let locale: GameModeLocale
    let style: GameTheme
    let mode: GameModeType
    
    let icon: String
    let title: String
    let description: String
    //let isSelected: Bool
    
    let onSelect: () -> Void
    
    // MARK: - Body
    var body: some View {
        ButtonMenu(
            title: title,
            subtitle: description,
            icon: icon,
            isSelected: false,
            style: .game(themeManager.currentThemeStyle, style),
            action: onSelect
        )
    }
}
