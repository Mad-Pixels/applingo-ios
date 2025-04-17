import SwiftUI

/// A view that displays the game content after a mode is selected.
struct GameModeViewGame<GameType: AbstractGame>: View {
    // MARK: - Properties
    let game: GameType

    // MARK: - Bindings
    @Binding var showGameContent: Bool
    @Binding var isPressedTrailing: Bool
    @Binding var isPresented: Bool

    // MARK: - Body
    var body: some View {
        BaseGameScreen(
            screen: .GameMode,
            game: game
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
                            isPressed: $isPressedTrailing,
                            onTap: {
                                isPresented = false
                            },
                            style: .close(ThemeManager.shared.currentThemeStyle)
                        )
                    }
                }
        }
        .ignoresSafeArea()
    }
}
