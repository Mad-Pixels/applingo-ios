import SwiftUI

/// A view that displays the game content after a mode is selected.
struct GameModeViewGame: View {
    // MARK: - Properties
    let game: any AbstractGame
    let mode: GameModeType
    
    // MARK: - Bindings
    @Binding var showGameContent: Bool
    @Binding var isPressedTrailing: Bool
    @Binding var isPresented: Bool
    
    // MARK: - Body
    var body: some View {
        BaseGameScreen(
            screen: .GameMode,
            game: game,
            mode: mode
        ) {
            game.makeView()
                .toolbarBackground(.clear, for: .navigationBar)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        GameScore(stats: game.stats)
                    }
                    ToolbarItem(placement: .principal) {
                        GameTab(
                                game: game,
                                style: .themed(ThemeManager.shared.currentThemeStyle)
                            )
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        ButtonNav(
                            style: .close(ThemeManager.shared.currentThemeStyle),
                            onTap: { isPresented = false },
                            isPressed: $isPressedTrailing
                        )
                    }
                }
        }
        .ignoresSafeArea()
    }
}
