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
    /// Initializes a new instance of DictionaryLocalDetails.
    /// - Parameters:
    ///   - style: Optional style configuration; if nil, a themed style is applied.
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
                            gameStart = true
                        },
                        style: .menu(ThemeManager.shared.currentThemeStyle)
                    )
                }
                .padding(style.padding)
                .glassBackground()
                .padding(.horizontal, 24)
            }
        }
        .fullScreenCover(isPresented: $gameStart) {
            GameMode(
                game: makeGame(type: game),
                isPresented: $gameStart
            )
        }
    }
    
    // MARK: - Private Methods
    /// Returns an instance of a game conforming to AbstractGame based on the selected type.
    /// - Parameter type: The selected game type.
    /// - Returns: An instance of a game.
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
}
