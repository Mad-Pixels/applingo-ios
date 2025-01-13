import SwiftUI

struct GameResultCardView: View {
    let stats: GameStatsModel
    let gameMode: GameModeEnum
    let onClose: () -> Void
    let onRestart: () -> Void
    
    private let style = GameCardStyle(theme: ThemeManager.shared.currentThemeStyle)
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.1)
                .edgesIgnoringSafeArea(.all)
                .allowsHitTesting(false)
            
            VStack(spacing: 24) {
                header
                statsGrid
                additionalStats
                actionButtons
            }
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(style.theme.backgroundSecondary)
                    .shadow(
                        color: style.theme.accentPrimary.opacity(0.2),
                        radius: 20,
                        x: 0,
                        y: 10
                    )
            )
            .padding(.horizontal, 32)
            .transition(.scale.combined(with: .opacity))
        }
        .ignoresSafeArea()
    }
    
    private var header: some View {
        VStack(spacing: 8) {
            Text(gameMode == .timeAttack ? LanguageManager.shared.localizedString(for: "GameTimesUp") :
                    LanguageManager.shared.localizedString(for: "GameOver"))
                .font(.system(.title, design: .rounded).weight(.bold))
                .foregroundColor(style.theme.textPrimary)
            
            Text(LanguageManager.shared.localizedString(for: "GameResults").uppercased())
                .font(.system(.title3, design: .rounded))
                .foregroundColor(style.theme.textSecondary)
        }
    }
    
    private var statsGrid: some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ],
            spacing: 16
        ) {
            StatItem(
                title: LanguageManager.shared.localizedString(for: "GameScore"),
                value: "\(stats.score)",
                icon: "star.fill",
                color: .yellow
            )
            
            StatItem(
                title: LanguageManager.shared.localizedString(for: "GameAccuracy"),
                value: String(format: "%.1f%%", stats.accuracy * 100),
                icon: "target",
                color: .green
            )
            
            StatItem(
                title: LanguageManager.shared.localizedString(for: "GameBestStreak"),
                value: "\(stats.bestStreak)",
                icon: "flame.fill",
                color: .orange
            )
            
            StatItem(
                title: gameMode == .timeAttack ? LanguageManager.shared.localizedString(for: "GameAvgTime") :
                    LanguageManager.shared.localizedString(for: "GameLivesLeft"),
                value: gameMode == .timeAttack ?
                    String(format: "%.1fs", stats.averageResponseTime) :
                    "\(stats.lives)",
                icon: gameMode == .timeAttack ? "clock.fill" : "heart.fill",
                color: gameMode == .timeAttack ? .blue : .red
            )
        }
    }
    
    private var additionalStats: some View {
        VStack(spacing: 12) {
            HStack {
                Text(LanguageManager.shared.localizedString(for: "GameCorrectAnswers"))
                Spacer()
                Text("\(stats.correctAnswers)")
                    .fontWeight(.semibold)
            }
            
            HStack {
                Text(LanguageManager.shared.localizedString(for: "GameWrongAnswers"))
                Spacer()
                Text("\(stats.wrongAnswers)")
                    .fontWeight(.semibold)
            }
            
            HStack {
                Text(LanguageManager.shared.localizedString(for: "GameTotalQuestions"))
                Spacer()
                Text("\(stats.totalAnswers)")
                    .fontWeight(.semibold)
            }
        }
        .font(.system(.body, design: .rounded))
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(style.theme.backgroundSecondary)
                .shadow(
                    color: style.theme.accentPrimary.opacity(0.1),
                    radius: 5,
                    x: 0,
                    y: 2
                )
        )
    }
    
    private var actionButtons: some View {
        HStack(spacing: 16) {
            Button(action: onClose) {
                Label("Close", systemImage: "xmark")
                    .font(.system(.body, design: .rounded).weight(.semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        Capsule()
                            .fill(Color(.systemGray))
                        )
                }
            
            Button(action: onRestart) {
                Label(LanguageManager.shared.localizedString(for: "GamePlayAgain"), systemImage: "arrow.clockwise")
                    .font(.system(.body, design: .rounded).weight(.semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        Capsule()
                            .fill(style.theme.accentPrimary)
                    )
            }
        }
    }
}

private struct StatItem: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.system(.title2, design: .rounded).weight(.bold))
                .foregroundColor(.primary)
            
            Text(title)
                .font(.system(.subheadline, design: .rounded))
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(
                    color: color.opacity(0.2),
                    radius: 8,
                    x: 0,
                    y: 4
                )
        )
    }
}
