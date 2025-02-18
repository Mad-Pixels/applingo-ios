import SwiftUI

struct GameResult: View {
    @EnvironmentObject var gameState: GameState
    @Environment(\.dismiss) var dismiss
    @StateObject private var locale = GameResultLocale()
    
    private var resultText: String {
        if let reason = gameState.endReason {
            switch reason {
            case .timeUp:
                return locale.timeUpText
            case .noLives:
                return locale.noLivesText
            default:
                return locale.gameOverText
            }
        }
        return locale.gameOverText
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text(resultText)
                .font(.largeTitle)
                .padding()
            
            Button(action: {
                dismiss()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    gameState.isGameOver = true
                }
            }) {
                Text(locale.closeButtonText)
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            
            Button(action: {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    if let mode = gameState.currentMode {
                        gameState.endReason = nil
                        gameState.initialize(for: mode)
                    }
                }
            }) {
                Text(locale.playAgainButtonText)
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
        }
        .padding()
    }
}
