import SwiftUI

/// A view that serves as the home screen where users can select a game type.
/// When a game is selected, it presents the GameMode view.
struct Home: View {
    
    // MARK: - State Objects
    
    /// Style configuration for the home screen.
    @StateObject private var style: HomeStyle
    /// Localization object for home texts.
    @StateObject private var locale = HomeLocale()
    
    // MARK: - Local State
    
    /// The selected game type.
    @State private var game: GameType = .quiz
    /// Flag to trigger the game start (presenting GameMode view).
    @State private var gameStart = false
    
    // MARK: - Initializer
    
    /// Initializes the Home view.
    /// - Parameter style: Optional style; if nil, a themed style is used.
    init(style: HomeStyle? = nil) {
        let initialStyle = style ?? .themed(ThemeManager.shared.currentThemeStyle)
        _style = StateObject(wrappedValue: initialStyle)
    }
    
    // MARK: - Helper Methods
    
    /// Returns an instance of a game conforming to AbstractGame based on the selected type.
    /// - Parameter type: The selected game type.
    /// - Returns: An instance of a game.
    private func makeGame(type: GameType) -> any AbstractGame {
        switch type {
        case .quiz:
            return Quiz()
        case .match:
            return Quiz() // Можно заменить на соответствующую реализацию.
        case .swipe:
            return Quiz() // Можно заменить на соответствующую реализацию.
        }
    }
    
    // MARK: - Body
    
    var body: some View {
        BaseScreen(screen: .Home) {
            ZStack {
                // Background view
                MainBackground()
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: style.spacing) {
                    ButtonAction(
                        title: locale.quizTitle.uppercased(),
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
        // Present the GameMode view as a full screen cover when gameStart is true.
        .fullScreenCover(isPresented: $gameStart) {
            GameMode(
                game: makeGame(type: game),
                isPresented: $gameStart
            )
        }
    }
}
