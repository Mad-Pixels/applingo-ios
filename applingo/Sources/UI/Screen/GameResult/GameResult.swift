import SwiftUI

struct GameResult: View {
    @EnvironmentObject var gameState: GameState
    @Environment(\.dismiss) var dismiss
    
    // Вычисляемое свойство для текста результата
    private var resultText: String {
        if let reason = gameState.endReason {
            switch reason {
            case .timeUp:
                return "Время вышло!"
            case .noLives:
                return "Игра окончена!"
            default:
                return "Конец игры"
            }
        }
        return "Конец игры"
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text(resultText)
                .font(.largeTitle)
                .padding()
            
            // Кнопка "Закрыть" – завершает игру и возвращает в главное меню.
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
            
            // Кнопка "Играть снова" – перезапускает игру.
            Button(action: {
                // Сначала закрываем модальное окно
                // Через небольшую задержку перезапускаем игру, не устанавливая флаг isGameOver
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    if let mode = gameState.currentMode {
                        // Сбрасываем причину завершения, чтобы не сработало dismiss() в BaseGameScreen
                        gameState.endReason = nil
                        // Перезапускаем игру
                        gameState.initialize(for: mode)
                    }
                }
            }) {
                Text("Играть снова")
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
