import SwiftUI

struct GameResult: View {
    @EnvironmentObject var gameState: GameState
    @Environment(\.dismiss) var dismiss
    @StateObject private var locale = GameResultLocale()
    @ObservedObject var stats: GameStats
    
    init(stats: GameStats) {
        self.stats = stats
    }
    
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
            Spacer()
            
            Text(resultText)
                .font(.largeTitle)
                .padding()
            
            // Статистика
            VStack(alignment: .leading, spacing: 12) {
                StatRow(title: locale.totalScoreText, value: "\(stats.totalScore)")
                StatRow(title: locale.accuracyText, value: String(format: "%.1f%%", stats.accuracy * 100))
                StatRow(title: locale.bestStreakText, value: "\(stats.correctAnswersStreak)")
                StatRow(title: locale.totalAnswersText, value: "\(stats.totalAnswers)")
                StatRow(title: locale.averageTimeText, value: String(format: "%.1f \(locale.screenSecText)", stats.averageResponseTime))
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .padding(.horizontal)
            
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
                        // Сбрасываем статистику, чтобы GameTab обновился сразу
                        stats.reset()
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
            
            Spacer()
        }
        .background(ThemeManager.shared.currentThemeStyle.backgroundPrimary)
        .padding()
    }
}

struct StatRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .bold()
        }
    }
}
