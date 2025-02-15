import SwiftUI

struct GameTab: View {
    @StateObject private var locale = GameTabLocale()
    let game: any AbstractGame
    @ObservedObject var stats: GameStats
    let style: GameTabStyle
    
    init(game: any AbstractGame, style: GameTabStyle) {
        self.game = game
        self.style = style
        self._stats = ObservedObject(wrappedValue: game.stats)
    }
   
    var body: some View {
        SectionBody {
            HStack(spacing: style.spacing) {
                GameTabViewScore(
                    score: stats.totalScore,
                    style: style,
                    locale: locale
                )
               
                Divider()
                    .frame(height: style.dividerHeight)
                    .foregroundColor(style.dividerColor)
               
                GameTabViewStreak(
                    streak: stats.streaks,
                    style: style,
                    locale: locale
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
        .padding(.top, 16)
    }

    @ViewBuilder
    private func makeModeSection(_ mode: GameModeType) -> some View {
        switch mode {
        case .practice:
            GameTabViewAccuracy(
                accuracy: stats.accuracy,
                style: style
            )
        case .survival where game.state.survivalState != nil:
            GameTabViewLives(
                lives: game.state.survivalState!.lives,
                style: style
            )
        case .time where game.state.timeState != nil:
            GameTabViewTimer(
                timer: game.state.timeState!,
                style: style
            )
        default:
            EmptyView()
        }
    }
}
