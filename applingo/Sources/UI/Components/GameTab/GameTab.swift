import SwiftUI

struct GameTab<GameType: AbstractGame>: View {
    @ObservedObject var stats: GameStats
    @ObservedObject private var game: GameType
    
    @ObservedObject private var gameState: GameState

    @StateObject private var style: GameTabStyle
    @StateObject private var locale = GameTabLocale()
    
    init(game: GameType, style: GameTabStyle = .themed(ThemeManager.shared.currentThemeStyle)) {
        _gameState = ObservedObject(wrappedValue: game.state)
        _stats = ObservedObject(wrappedValue: game.stats)
        _game = ObservedObject(wrappedValue: game)
        _style = StateObject(wrappedValue: style)
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
               
                Group {
                    if let mode = gameState.currentMode {
                        makeModeSection(mode)
                    } else {
                        Color.clear
                    }
                }
                .frame(width: style.modeSectionSize)
            }
            .padding(.horizontal, style.padding)
            .padding(.vertical, -4)
        }
        .padding(.top, style.padding)
        .frame(
            minWidth: UIScreen.main.bounds.width * style.tabWidth,
            maxWidth: UIScreen.main.bounds.width * style.tabWidth,
            minHeight: 64,
            maxHeight: 64
        )
        .fixedSize(horizontal: true, vertical: false)
        .frame(maxWidth: .infinity)
    }
    
    @ViewBuilder
    private func makeModeSection(_ mode: GameModeType) -> some View {
        switch mode {
        case .practice:
            GameTabViewAccuracy(
                accuracy: stats.accuracy,
                style: style
            )
        case .survival where gameState.survivalState != nil:
            GameTabViewLives(
                lives: gameState.survivalState!.lives,
                style: style
            )
        case .time where gameState.timeState != nil:
            GameTabViewTimer(
                timer: gameState.timeState!,
                style: style
            )
        default:
            EmptyView()
        }
    }
}
