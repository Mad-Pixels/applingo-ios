import SwiftUI

struct GameQuiz: View {
    @ObservedObject var game: Quiz
    @StateObject private var style: GameQuizStyle
    @StateObject private var locale = GameQuizLocale()
    
    init(game: Quiz, style: GameQuizStyle? = nil) {
        self.game = game
        let initialStyle = style ?? .themed(ThemeManager.shared.currentThemeStyle)
        _style = StateObject(wrappedValue: initialStyle)
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                GameTab(
                    game: game,
                    style: .themed(ThemeManager.shared.currentThemeStyle)
                )
                Text("Quiz Game Content")
                    .font(.largeTitle)
            }
        }
    }
}
