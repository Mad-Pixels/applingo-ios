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
                
                GameTabViewAccuracy(
                    accuracy: game.stats.accuracy,
                    style: style
                )
                
                if let mode = game.state.currentMode {
                    Divider()
                        .frame(height: style.dividerHeight)
                        .foregroundColor(style.dividerColor)
                    
                    makeModeSection(mode)
                }
            }
            .padding(.horizontal, style.padding)
        }
    }
    
    @ViewBuilder
    private func makeModeSection(_ mode: GameModeType) -> some View {
        switch mode {
        case .survival where game.state.survivalState != nil:
            GameTabViewLives(lives: game.state.survivalState!.lives, style: style)
        case .time where game.state.timeState != nil:
            GameTabViewTimer(timeLeft: game.state.timeState!.timeLeft, style: style)
        default:
            EmptyView()
        }
    }
}
