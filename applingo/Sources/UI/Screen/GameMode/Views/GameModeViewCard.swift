import SwiftUI

/// A view that represents a single game mode card in the selection list.
struct GameModeViewCard: View {
    
    // MARK: - Environment
    
    @EnvironmentObject private var themeManager: ThemeManager
    
    // MARK: - Properties
    
    let mode: GameModeType
    let icon: String
    let title: String
    let description: String
    /// The game theme to style the card.
    let style: GameTheme
    /// Indicates if the card is currently selected.
    let isSelected: Bool
    /// Closure executed when the card is tapped.
    let onSelect: () -> Void
    
    // MARK: - Body
    
    var body: some View {
        ButtonMenu(
            title: title,
            subtitle: description,
            icon: icon,
            isSelected: isSelected,
            style: .game(themeManager.currentThemeStyle, style),
            action: onSelect
        )
    }
}
