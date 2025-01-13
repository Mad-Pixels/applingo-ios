import SwiftUI

struct Home: View {
    @StateObject private var style: HomeStyle
    @StateObject private var locale = HomeLocale()
    
    @State private var showMatchHuntGame = false
    @State private var showVerifyItGame = false
    @State private var showQuizGame = false
    
    init(style: HomeStyle? = nil) {
        let initialStyle = style ?? .themed(ThemeManager.shared.currentThemeStyle)
        _style = StateObject(wrappedValue: initialStyle)
    }
    
    var body: some View {
        BaseScreen(screen: .main) {
            ZStack {
                MainBackground().edgesIgnoringSafeArea(.all)
                
                VStack(spacing: style.spacing) {
                    ButtonIcon(
                        title: locale.quizTitle,
                        icon: "laser.burst",
                        action: { showQuizGame = true },
                        style: .asGameSelect(ThemeManager.shared.currentThemeStyle.quizTheme)
                    )
                    
                    ButtonIcon(
                        title: locale.matchHuntTitle,
                        icon: "puzzlepiece",
                        action: { showMatchHuntGame = true },
                        style: .asGameSelect(ThemeManager.shared.currentThemeStyle.matchTheme)
                    )
                    
                    ButtonIcon(
                        title: locale.verifyItTitle,
                        icon: "number",
                        action: { showVerifyItGame = true },
                        style: .asGameSelect(ThemeManager.shared.currentThemeStyle.swipeTheme)
                    )
                }
                .padding(style.padding)
                .glassBackground()
                .padding(.horizontal, 24)
            }
        }
        .fullScreenCover(isPresented: $showQuizGame) {
            GameQuizView(isPresented: $showQuizGame)
        }
        .fullScreenCover(isPresented: $showMatchHuntGame) {
            GameMatchHuntView(isPresented: $showMatchHuntGame)
        }
        .fullScreenCover(isPresented: $showVerifyItGame) {
            GameVerifyItView(isPresented: $showVerifyItGame)
        }
    }
}
