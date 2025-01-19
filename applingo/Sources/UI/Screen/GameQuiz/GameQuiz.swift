import SwiftUI

struct GameQuiz: View {
    @StateObject private var game: Quiz
    @StateObject private var style: GameQuizStyle
    @StateObject private var locale = GameQuizLocale()
    
    init(style: GameQuizStyle? = nil) {
        let initialStyle = style ?? .themed(ThemeManager.shared.currentThemeStyle)
        _game = StateObject(wrappedValue: Quiz())
        _style = StateObject(wrappedValue: initialStyle)
    }
    
    var body: some View {
        BaseGameScreen(game: game) {
            VStack(spacing: 20) {
                Text("Quiz Game Content")
                    .font(.largeTitle)
            }
        }
    }
}
