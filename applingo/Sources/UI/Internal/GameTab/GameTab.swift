import SwiftUI

struct GameTab: View {
    @StateObject private var locale = GameTabLocale()
    @ObservedObject var game: Quiz
    @ObservedObject var stats: GameStats // добавляем это
    let style: GameTabStyle
    
    init(game: Quiz, style: GameTabStyle) {
        self.game = game
        self.style = style
        self._stats = ObservedObject(wrappedValue: game.stats) // и это
    }
   
    var body: some View {
        SectionBody {
            HStack(spacing: style.spacing) {
                GameTabViewScore(
                    score: stats.totalScore, // теперь берем из stats
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
                    timer: game.state.timeState!, // передаем GameTimer
                    style: style
                )
            default:
                EmptyView()
            }
        }
}
