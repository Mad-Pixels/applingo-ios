import SwiftUI

class QuizGame: GameProtocol {
    var type: GameType = .quiz
    var minimumWordsRequired: Int = 12
    var availableModes: [GameModeEnum] = [.practice, .survival, .timeAttack]
    var isReadyToPlay: Bool { true }
    
    func start(mode: GameModeEnum) {}
    func end() {}
}

struct QuizGameContent: View {
    @Binding var isPresented: Bool      // Пуш «Back»
    @Binding var closeFullScreen: Bool  // Закрыть всё

    var body: some View {
        VStack(spacing: 20) {
            Text("Quiz Game Content")
                .font(.largeTitle)
            
            // Кнопка закрыть только текущий пуш
            Button("Back to GameMode") {
                isPresented = false
            }

            // Кнопка закрыть всё (вернуться в Home)
            Button("Close FullScreen") {
                closeFullScreen = false
            }
        }
        .navigationBarTitle("Quiz Game", displayMode: .inline)
        .toolbar {
            // «Крестик» справа тоже закрывает всё
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    closeFullScreen = false
                }) {
                    Image(systemName: "xmark")
                }
            }
        }
    }
}
