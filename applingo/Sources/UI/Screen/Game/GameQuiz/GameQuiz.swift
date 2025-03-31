import SwiftUI

struct GameQuiz: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var style: GameQuizStyle
    @StateObject private var locale = GameQuizLocale()
    @StateObject private var viewModel: QuizViewModel
    
    @ObservedObject var game: Quiz
    
    init(
        game: Quiz,
        style: GameQuizStyle = .themed(ThemeManager.shared.currentThemeStyle)
    ) {
        _viewModel = StateObject(wrappedValue: QuizViewModel(game: game))
        _style = StateObject(wrappedValue: style)
        self.game = game
    }
    
    var body: some View {
        ZStack {
            style.backgroundColor.ignoresSafeArea()
                
            if let card = viewModel.currentCard {
                VStack(spacing: style.optionsSpacing) {
                    GameQuizViewQuestion(
                        locale: locale,
                        style: style,
                        question: card.question
                    )
                    .padding(.bottom, 24)
                    .padding(.top, 64)
                                
                    VStack(spacing: style.optionsSpacing) {
                        ForEach(card.options, id: \.self) { option in
                            GameQuizViewAnswer(
                                style: style,
                                locale: locale,
                                option: option,
                                onSelect: { viewModel.handleAnswer(option) },
                                viewModel: viewModel
                            )
                        }
                    }
                }
                .padding()
            }
        }
        .padding()
        .onAppear {
            viewModel.generateCard()
        }
        .onReceive(game.state.$isGameOver) { isGameOver in
            if isGameOver {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    dismiss()
                }
            }
        }
    }
}
