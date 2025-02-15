import SwiftUI

/// A view that displays the game content after a mode is selected.
struct GameModeViewGame: View {
    // MARK: - Properties
    let game: any AbstractGame
    let mode: GameModeType
    
    @State private var isPressedLeading = false
    @Binding var showGameContent: Bool
    
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
//                    ToolbarItem(placement: .navigationBarLeading) {
//                        ButtonNav(
//                            style: .back(ThemeManager.shared.currentThemeStyle),
//                            onTap: {
//                                showGameContent = false
//                            },
//                            isPressed: $isPressedLeading
//                        )
//                    }
                    ToolbarItem(placement: .principal) {
                        GameTab(
                            game: game as! Quiz,
                            style: .themed(ThemeManager.shared.currentThemeStyle)
                        )
                    }
                }
        }
        .ignoresSafeArea()
    }
}
