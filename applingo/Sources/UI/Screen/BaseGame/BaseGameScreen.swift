import SwiftUI

struct BaseGameScreen<Content: View>: View {
    @Environment(\.presentationMode) private var presentationMode
    
    private let game: AbstractGame
    private let content: Content
    
    @State private var selectedMode: GameModeEnum = .practice
    @State private var showGame = false
    @State private var isCoverPresented = true 
    
    init(
        game: AbstractGame,
        @ViewBuilder content: () -> Content
    ) {
        self.game = game
        self.content = content()
    }
    
    var body: some View {
        if !game.isReadyToPlay {
            Text("Not enough words to play")
        } else {
            NavigationLink(isActive: $showGame) {
                content
                    .navigationBarBackButtonHidden(true)
                    .navigationBarItems(
                        leading: Button(action: { showGame = false }) {
                            Image(systemName: "chevron.left")
                        }
                    )
            } label: {
                GameMode(
                    isCoverPresented: $isCoverPresented,
                    selectedMode: $selectedMode,
                    startGame: { showGame = true }
                )
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(
                    leading: Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        Image(systemName: "chevron.left")
                    }
                )
            }
        }
    }
}
