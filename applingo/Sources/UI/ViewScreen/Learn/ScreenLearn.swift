import SwiftUI

struct ScreenLearn: View {
    @StateObject private var style: ScreenLearnStyle
    @StateObject private var locale = ScreenLearnLocale()
    
    @State private var showMatchHuntGame = false
    @State private var showVerifyItGame = false
    @State private var showQuizGame = false
    
    init(style: ScreenLearnStyle? = nil) {
        let initialStyle = style ?? .themed(ThemeManager.shared.currentThemeStyle)
        _style = StateObject(wrappedValue: initialStyle)
    }
    
    var body: some View {
        BaseViewScreen(screen: .main) {
            ZStack {
                MainBackground().edgesIgnoringSafeArea(.all)
                
                VStack(spacing: style.spacing) {
                    GameButton(
                        title: locale.quizTitle,
                        icon: "laser.burst",
                        action: { showQuizGame = true }
                    )
                    
                    GameButton(
                        title: locale.matchHuntTitle,
                        icon: "puzzlepiece",
                        action: { showMatchHuntGame = true }
                    )
                    
                    GameButton(
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
