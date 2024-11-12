import SwiftUI

struct CompToolbarGame: View {
    
    let gameMode: GameMode
    let stats: GameStatsModel
    @Binding var isGameActive: Bool
    
    var body: some View {
        let theme = ThemeManager.shared.currentThemeStyle
        
        HStack {
            Menu {
                Button("Practice") { /* switch mode */ }
                Button("Survival") { /* switch mode */ }
                Button("Time Attack") { /* switch mode */ }
            } label: {
                HStack {
                    Image(systemName: modeIcon)
                    Text(modeTitle)
                }
                .foregroundColor(theme.baseTextColor)
            }
            
            Divider()
                .background(theme.accentColor)
                .frame(height: 20)
            
            // Статистика в зависимости от режима
            Group {
                switch gameMode {
                case .practice:
                    HStack {
                        Image(systemName: "star.fill")
                        Text("\(stats.score)")
                        Text("Streak: \(stats.streak)")
                    }
                case .survival:
                    HStack {
                        ForEach(0..<3) { index in
                            Image(systemName: index < stats.lives ? "heart.fill" : "heart")
                                .foregroundColor(index < stats.lives ? .red : theme.secondaryTextColor)
                        }
                        Text("\(stats.score)")
                    }
                case .timeAttack:
                    HStack {
                        Image(systemName: "clock")
                        Text(timeString)
                        Text("\(stats.score)")
                    }
                }
            }
            .foregroundColor(theme.baseTextColor)
            
            Spacer()
            
            // Accuracy
            Text("\(Int((Double(stats.correctAnswers) / Double(max(stats.correctAnswers + stats.wrongAnswers, 1))) * 100))%")
                .foregroundColor(theme.secondaryTextColor)
        }
        .padding()
        .background(theme.backgroundBlockColor.opacity(0.3))
    }
    
    private var modeIcon: String {
        switch gameMode {
        case .practice: return "book.fill"
        case .survival: return "heart.fill"
        case .timeAttack: return "clock.fill"
        }
    }
    
    private var modeTitle: String {
        switch gameMode {
        case .practice: return "Practice"
        case .survival: return "Survival"
        case .timeAttack: return "Time Attack"
        }
    }
    
    private var timeString: String {
        let minutes = Int(stats.timeRemaining) / 60
        let seconds = Int(stats.timeRemaining) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}
