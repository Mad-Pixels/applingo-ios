import SwiftUI

/// A view that displays the game tab with score, streak, and mode details.
/// The component maintains a fixed width of 80% of the screen and remains centered.
/// The mode section is wrapped in a fixed container to ensure consistent sizing,
/// even when data is initially missing.
struct GameTab<GameType: AbstractGame>: View {
    @ObservedObject var stats: GameStats
    @ObservedObject private var game: GameType
    
    // MARK: - State Objects
    @StateObject private var style: GameTabStyle
    @StateObject private var locale = GameTabLocale()
    
    // MARK: - Initializer
    init(game: GameType, style: GameTabStyle? = nil) {
        _style = StateObject(wrappedValue: style ?? .themed(ThemeManager.shared.currentThemeStyle))
        _stats = ObservedObject(wrappedValue: game.stats)
        _game = ObservedObject(wrappedValue: game)
    }
    
    // MARK: - Body
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
                    if let mode = game.state.currentMode {
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
            maxWidth: UIScreen.main.bounds.width * style.tabWidth
        )
        .fixedSize(horizontal: true, vertical: false)
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - Private Methods
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
