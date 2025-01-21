import SwiftUI

struct GameModeViewGame: View {
    let game: any AbstractGame
    let mode: GameModeType
    @Binding var showGameContent: Bool
    @State private var isPressedLeading = false

    var body: some View {
        BaseGameScreen(screen: .game, game: game) {
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
                }
        }
        .ignoresSafeArea()
    }
}
