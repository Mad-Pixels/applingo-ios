import SwiftUI

struct GameQuiz: View {
    @StateObject private var style: GameQuizStyle
    @StateObject private var locale = GameQuizLocale()
    
    init(style: GameQuizStyle? = nil) {
        let initialStyle = style ?? .themed(ThemeManager.shared.currentThemeStyle)
        _style = StateObject(wrappedValue: initialStyle)
    }
    
    var body: some View {
        ZStack {
            MainBackground()
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Text("Quiz Game Content")
                    .font(.largeTitle)
            }
        }
    }
}
