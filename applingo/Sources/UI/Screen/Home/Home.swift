import SwiftUI

struct Home: View {
    @StateObject private var style: HomeStyle
    @StateObject private var locale = HomeLocale()
    @State private var showGameView = false
    @State private var game: GameType?
    
    init(style: HomeStyle? = nil) {
        let initialStyle = style ?? .themed(ThemeManager.shared.currentThemeStyle)
        _style = StateObject(wrappedValue: initialStyle)
    }
   
    var body: some View {
        BaseScreen(
            screen: .main,
            title: ""
        ) {
            Color.clear
           
            ZStack {
                MainBackground()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea()
               
                VStack {
                    Spacer()
                   
                    VStack(spacing: style.spacing) {
                        ButtonIcon(
                            title: locale.quizTitle,
                            icon: "laser.burst",
                            action: {
                                game = .quiz
                                showGameView = true
                            },
                            style: .asGameSelect(ThemeManager.shared.currentThemeStyle.quizTheme)
                        )
                       
                        ButtonIcon(
                            title: locale.matchHuntTitle,
                            icon: "puzzlepiece",
                            action: {
                                game = .match
                                showGameView = true
                            },
                            style: .asGameSelect(ThemeManager.shared.currentThemeStyle.matchTheme)
                        )
                       
                        ButtonIcon(
                            title: locale.verifyItTitle,
                            icon: "number",
                            action: {
                                game = .swipe
                                showGameView = true
                            },
                            style: .asGameSelect(ThemeManager.shared.currentThemeStyle.swipeTheme)
                        )
                    }
                    .padding(style.padding)
                    .glassBackground()
                    .padding(.horizontal, 24)

                    Spacer()
                }
            }
            .fullScreenCover(isPresented: $showGameView) {
                if let game = game {
                    switch game {
                    case .quiz:
                        GameQuiz()
                    case .match:
                        GameQuiz()
                    case .swipe:
                        GameQuiz()
                    }
                }
            }
        }
    }
}
