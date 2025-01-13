import SwiftUI

struct BaseGameScreen<Content: View>: View {
    @Environment(\.presentationMode) private var presentationMode
    
    private let game: GameProtocol
    private let content: Content
    
    @State private var selectedMode: GameModeEnum = .practice
    @State private var showGame = false
    
    // Добавляем флаг для передачи в GameMode
    @Binding var isCoverPresented: Bool
    
    init(
        game: GameProtocol,
        isCoverPresented: Binding<Bool>,
        @ViewBuilder content: () -> Content
    ) {
        self.game = game
        self._isCoverPresented = isCoverPresented
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
                // Теперь передаем isCoverPresented
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
