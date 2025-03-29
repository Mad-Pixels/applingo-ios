import SwiftUI

struct Home: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    @StateObject private var style: HomeStyle
    @StateObject private var locale = HomeLocale()
    
    @State private var game: GameType = .quiz
    @State private var gameStart = false
    
    /// Initializes the Home.
    /// - Parameter style: Optional style configuration; if nil, a themed style is applied.
    init(
        style: HomeStyle = .themed(ThemeManager.shared.currentThemeStyle)
    ) {
        _style = StateObject(wrappedValue: style)
    }
    
    var body: some View {
        BaseScreen(
            screen: .Home
        ) {
            ZStack {
                BackgroundMain()
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: style.spacing) {
                    ButtonAction(
                        title: locale.screenGameQuiz.uppercased(),
                        action: {
                            game = .quiz
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                gameStart = true
                            }
                        },
                        style: .menu(themeManager.currentThemeStyle)
                    )
                    
                    ButtonAction(
                        title: locale.screenGameMatchup.uppercased(),
                        action: {
                            game = .match
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                gameStart = true
                            }
                        },
                        style: .menu(themeManager.currentThemeStyle)
                    )
                    
                    ButtonAction(
                        title: locale.screenGameSwipe.uppercased(),
                        action: {
                            game = .swipe
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                gameStart = true
                            }
                        },
                        style: .menu(themeManager.currentThemeStyle)
                    )
                }
                .padding(style.padding)
                .padding(.horizontal, 24)
            }
        }
        .fullScreenCover(isPresented: $gameStart) {
            switch game {
            case .quiz:
                GameMode(game: Quiz(), isPresented: $gameStart)
            case .match:
                GameMode(game: Match(), isPresented: $gameStart)
            case .swipe:
                GameMode(game: Swipe(), isPresented: $gameStart)
            }
        }
        .id(game)
    }
}
