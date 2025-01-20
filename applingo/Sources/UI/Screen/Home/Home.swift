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
    
    var body: some View {
        ZStack {
            MainBackground()
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: style.spacing) {
                ButtonIcon(
                    title: locale.quizTitle,
                    icon: "laser.burst",
                    action: {
                        game = .quiz
                        gameStart = true
                    },
                    style: .asGameSelect(ThemeManager.shared.currentThemeStyle.quizTheme)
                )
                
                ButtonIcon(
                    title: locale.matchHuntTitle,
                    icon: "puzzlepiece",
                    action: {
                        game = .match
                        gameStart = true
                    },
                    style: .asGameSelect(ThemeManager.shared.currentThemeStyle.matchTheme)
                )
                
                ButtonIcon(
                    title: locale.verifyItTitle,
                    icon: "number",
                    action: {
                        game = .swipe
                        gameStart = true
                    },
                    style: .asGameSelect(ThemeManager.shared.currentThemeStyle.swipeTheme)
                )
            }
            .padding(style.padding)
            .glassBackground()
            .padding(.horizontal, 24)
        }
        .fullScreenCover(isPresented: $gameStart) {
            GameMode(game: game, isPresented: $gameStart)
        }
    }
}
