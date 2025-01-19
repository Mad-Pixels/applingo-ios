import SwiftUI

struct BaseGameScreen: View {
    @Binding var isPresented: Bool
    let gameType: GameType
    
    @State private var selectedMode: GameModeEnum = .practice
    @State private var showGameContent = false
    
    var body: some View {
        NavigationView {
            GameMode(
                isCoverPresented: $isPresented,
                gameType: gameType,
                selectedMode: $selectedMode,
                showGameContent: $showGameContent
            )
        }
        .edgesIgnoringSafeArea(.all)
    }
}
