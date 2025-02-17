import SwiftUI

struct GameResult: View {
    @EnvironmentObject var gameState: GameState
    @Environment(\.dismiss) var dismiss
    
//    private var resultText: String {
//        if let reason = gameState.endReason {
//            switch reason {
//            case .timeUp:
//                return "Время вышло!"
//            case .noLives:
//                return "Игра окончена!"
//            default:
//                return "Конец игры"
//            }
//        }
//        return "Конец игры"
//    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("resultText")
                .font(.largeTitle)
                .padding()
            
            Button(action: {
                dismiss()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    gameState.isGameOver = true
                }
            }) {
                Text("Закрыть")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
        }
        .padding()
    }
}
