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
                        action: { showQuizGame = true }
                    )
                    
                    ButtonIcon(
                        title: locale.matchHuntTitle,
                        icon: "puzzlepiece",
                        action: { showMatchHuntGame = true }
                    )
                    
                    ButtonIcon(
                        title: locale.verifyItTitle,
                        icon: "number",
                        action: { showVerifyItGame = true }
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
