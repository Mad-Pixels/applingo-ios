import SwiftUI

/// A view that displays the game content after a mode is selected.
struct GameModeViewGame: View {
    
    // MARK: - Properties
    
    /// The game instance.
    let game: any AbstractGame
    /// The selected game mode.
    let mode: GameModeType
    /// Binding flag to control the display of game content.
    @Binding var showGameContent: Bool
    /// Flag for button press animation on the leading toolbar button.
    @State private var isPressedLeading = false
    
    // MARK: - Body
    
    var body: some View {
        BaseGameScreen(screen: .GameMode, game: game) {
            game.makeView()
                .onAppear {
                    game.start(mode: mode)
                }
                .toolbarBackground(.clear, for: .navigationBar)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        ButtonNav(
                            style: .back(ThemeManager.shared.currentThemeStyle),
                            onTap: {
                                showGameContent = false
                            },
                            isPressed: $isPressedLeading
                        )
                    }
                    
                    ToolbarItem(placement: .principal) {
                        GameTab(
                            game: game,
                            style: .themed(ThemeManager.shared.currentThemeStyle)
                        )
                    }
                }
        }
        .ignoresSafeArea()
    }
}
