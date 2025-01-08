import SwiftUI

struct CompGameScorePointsView: View {
    let score: GameScoreAnimationModel
    
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 70)
            
            HStack(spacing: 4) {
                if !score.reason.icon.isEmpty {
                    Image(systemName: score.reason.icon)
                        .foregroundColor(score.reason.color)
                }
                Text(ScoreFormatter.formatScore(score.points, showPlus: true))
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(score.points >= 0 ? .green : .red)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                ThemeManager.shared.currentThemeStyle.backgroundSecondary
                    .opacity(0.9)
                    .clipShape(Capsule())
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
            )
        }
        .transition(.scale.combined(with: .opacity))
    }
}
