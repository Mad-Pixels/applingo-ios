import SwiftUI

struct GameTab: View {
    let game: any AbstractGame
    let style: GameTabStyle
   
    var body: some View {
        SectionBody {
            HStack(spacing: style.spacing) {
                GameTabViewScore(
                    score: game.stats.score,
                    style: style
                )
               
                Divider()
                    .frame(height: style.dividerHeight)
                    .foregroundColor(style.dividerColor)
               
                GameTabViewStreak(
                    streak: game.stats.perfectStreaks,
                    style: style
                )
               
                Divider()
                    .frame(height: style.dividerHeight)
                    .foregroundColor(style.dividerColor)
               
                if let mode = game.state.currentMode {
                    makeModeSection(mode)
                }
            }
            .padding(.horizontal, style.padding)
            .padding(.vertical, -4)
        }
    }
   
    @ViewBuilder
    private func makeModeSection(_ mode: GameModeType) -> some View {
        switch mode {
        case .practice:
            GameTabViewAccuracy(
                accuracy: game.stats.accuracy,
                style: style
            )
        case .survival where game.state.survivalState != nil:
            GameTabViewLives(lives: game.state.survivalState!.lives, style: style)
        case .time where game.state.timeState != nil:
            GameTabViewTimer(timeLeft: game.state.timeState!.timeLeft, style: style)
        default:
            EmptyView()
        }
    }
}
