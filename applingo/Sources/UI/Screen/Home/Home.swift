import SwiftUI

/// A view that serves as the home screen where users can select a game type.
/// When a game is selected, it presents the GameMode view.
struct Home: View {
    // MARK: - State Objects
    @StateObject private var style: HomeStyle
    @StateObject private var locale = HomeLocale()
    
    // MARK: - Local State
    @State private var game: GameType = .quiz
    @State private var gameStart = false
    
    // MARK: - Initializer
    /// Initializes a new instance of Home.
    /// - Parameter style: Optional style configuration; if nil, a themed style is applied.
    init(
        style: HomeStyle? = nil
    ) {
        _style = StateObject(wrappedValue: style ?? .themed(ThemeManager.shared.currentThemeStyle))
    }
    
    // MARK: - Body
    var body: some View {
        BaseScreen(
            screen: .Home
        ) {
            ZStack {
                MainBackground()
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
                        style: .menu(ThemeManager.shared.currentThemeStyle)
                    )
                    
                    ButtonAction(
                        title: locale.screenGameMatchup.uppercased(),
                        action: {
                            game = .match
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                gameStart = true
                            }
                        },
                        style: .menu(ThemeManager.shared.currentThemeStyle)
                    )
                }
                .padding(style.padding)
                //.glassBackground()
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
                GameMode(game: Quiz(), isPresented: $gameStart)
            }
        }
        .id(game)
    }
}
