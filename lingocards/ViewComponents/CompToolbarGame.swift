import SwiftUI

struct CompToolbarGame: View {
    @EnvironmentObject var gameStats: GameStatsModel

    let gameMode: GameMode
    @Binding var isGameActive: Bool

    var body: some View {
        let theme = ThemeManager.shared.currentThemeStyle

        HStack(spacing: 10) {
            HStack(spacing: 12) {
                ScoreIndicator(score: gameStats.score)
                StreakIndicator(streak: gameStats.streak)
            }
            Spacer(minLength: 8)
            switch gameMode {
            case .practice:
                AccuracyView(stats: gameStats)
            case .timeAttack:
                HStack(spacing: 6) {
                    TimeIndicator(timeRemaining: gameStats.timeRemaining)
                    AccuracyView(stats: gameStats)
                }
            case .survival:
                HStack(spacing: 6) {
                    LivesIndicator(lives: gameStats.lives)
                    AccuracyView(stats: gameStats)
                }
            }
        }
        .padding(.horizontal, 6)
        .padding(.vertical, 8)
        .background {
            RoundedRectangle(cornerRadius: 16)
                .fill(theme.backgroundBlockColor)
                .shadow(color: theme.secondaryTextColor.opacity(0.3), radius: 5, x: 0, y: 2)
        }
    }
}


private struct ScoreIndicator: View {
    let score: Int

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "star.fill")
                .foregroundColor(.yellow)
                .imageScale(.medium)
            Text(formatLargeNumber(score, maxValue: 99999))
                .font(.system(.title3, design: .rounded))
                .fontWeight(.bold)
                .monospacedDigit()
                .frame(minWidth: 55, alignment: .leading)
        }
    }
}

private struct StreakIndicator: View {
    let streak: Int

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "flame.fill")
                .foregroundColor(streakColor)
                .imageScale(.medium)
                .scaleEffect(streak > 0 ? 1.1 : 1.0)
                .animation(.easeInOut(duration: 0.2), value: streak)
            Text(formatLargeNumber(streak, maxValue: 999))
                .font(.system(.title3, design: .rounded))
                .fontWeight(.bold)
                .monospacedDigit()
                .foregroundColor(streakColor)
                .frame(minWidth: 28, alignment: .leading)
        }
        .opacity(streak > 0 ? 1 : 0.5)
    }

    private var streakColor: Color {
        if streak >= 10 {
            return .red
        } else if streak >= 5 {
            return .orange
        } else {
            return .yellow
        }
    }
}

private struct LivesIndicator: View {
    let lives: Int

    var body: some View {
        HStack(spacing: 1) {
            ForEach(0..<3) { index in
                Image(systemName: index < lives ? "heart.fill" : "heart")
                    .foregroundColor(index < lives ? .red : .gray)
                    .scaleEffect(index < lives ? 1.1 : 1.0)
                    .animation(.easeInOut(duration: 0.2), value: lives)
            }
        }
    }
}

private struct TimeIndicator: View {
    let timeRemaining: TimeInterval

    var body: some View {
        Text(timeString)
            .font(.system(.title3, design: .rounded))
            .fontWeight(.bold)
            .monospacedDigit()
            .foregroundColor(timeColor)
            .frame(minWidth: 48)
            .animation(.easeInOut(duration: 0.3), value: timeRemaining)
    }

    private var timeString: String {
        let minutes = Int(timeRemaining) / 60
        let seconds = Int(timeRemaining) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }

    private var timeColor: Color {
        if timeRemaining <= 10 {
            return .red
        } else if timeRemaining <= 30 {
            return .orange
        } else {
            return .primary
        }
    }
}

private struct AccuracyView: View {
    let stats: GameStatsModel

    var body: some View {
        Text("\(Int(calculateAccuracy() * 100))%")
            .font(.system(.body, design: .rounded))
            .fontWeight(.bold)
            .monospacedDigit()
            .foregroundColor(accuracyColor)
            .frame(minWidth: 38, alignment: .trailing)
    }

    private func calculateAccuracy() -> Double {
        let total = Double(stats.correctAnswers + stats.wrongAnswers)
        guard total > 0 else { return 0 }
        return Double(stats.correctAnswers) / total
    }

    private var accuracyColor: Color {
        let accuracy = calculateAccuracy()
        if accuracy >= 0.8 {
            return .green
        } else if accuracy >= 0.6 {
            return .yellow
        } else {
            return .red
        }
    }
}

private func formatLargeNumber(_ number: Int, maxValue: Int) -> String {
    if number > maxValue {
        switch maxValue {
        case 99999:
            return "99K+"
        case 999:
            return "999+"
        default:
            return "\(maxValue)+"
        }
    }
    if number >= 1000 {
        let thousands = Double(number) / 1000.0
        return String(format: "%.1fK", thousands)
    }
    return "\(number)"
}
