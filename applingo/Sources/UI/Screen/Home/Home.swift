import SwiftUI

struct Home: View {
    @StateObject private var style: HomeStyle
    @StateObject private var locale = HomeLocale()
    @State private var game: GameType = .quiz
    @State private var gameStart = false
   
    init(style: HomeStyle? = nil) {
        let initialStyle = style ?? .themed(ThemeManager.shared.currentThemeStyle)
        _style = StateObject(wrappedValue: initialStyle)
    }

    private func makeGame(type: GameType) -> any AbstractGame {
        switch type {
        case .quiz:
            return Quiz()
        case .match:
            return Quiz()
        case .swipe:
            return Quiz()
        }
    }

    var body: some View {
        BaseScreen(screen: .game) {
            ZStack {
                MainBackground()
                    .edgesIgnoringSafeArea(.all)
               
                VStack(spacing: style.spacing) {
                    ButtonAction(
                        title: locale.quizTitle.uppercased(),
                        action: {
                            game = .quiz
                            gameStart = true
                        },
                        style: .menu(
                            ThemeManager.shared.currentThemeStyle
                        )
                    )
                }
                .padding(style.padding)
                .glassBackground()
                .padding(.horizontal, 24)
            }
        }
        .fullScreenCover(isPresented: $gameStart) {
            GameMode(game: makeGame(type: game), isPresented: $gameStart)
        }
    }
}
