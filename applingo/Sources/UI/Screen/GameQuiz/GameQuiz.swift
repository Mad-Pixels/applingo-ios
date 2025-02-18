import SwiftUI

/// A view that presents a quiz game interface by generating quiz cards from a word cache and handling user answers.
///
/// The `GameQuiz` view uses a dedicated view model (`QuizViewModel`) to encapsulate the logic for generating quiz cards
/// and processing user responses. It observes the state of the underlying quiz game model (`Quiz`) to react to changes such as
/// cache loading and game over conditions. When a new card is generated, it displays the question using `GameQuizViewQuestion`
/// and answer options using `GameQuizViewAnswer`. Upon the user selecting an answer, the view model processes the answer,
/// updates game statistics, and eventually generates a new quiz card. If the game state indicates that the game is over,
/// the view dismisses itself.
///
/// - Environment:
///   - `dismiss`: A function that dismisses the current view, typically used when the game is over.
/// - State Objects:
///   - `style`: The visual style for the quiz interface.
///   - `locale`: Provides localized strings for the quiz view.
///   - `viewModel`: The view model that handles quiz card generation and answer processing.
/// - Observed Objects:
///   - `game`: The quiz game model that holds the core game logic and state.
struct GameQuiz: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var style: GameQuizStyle
    @StateObject private var locale = GameQuizLocale()
    @StateObject private var viewModel: QuizViewModel
    @ObservedObject var game: Quiz
    
    init(game: Quiz, style: GameQuizStyle? = nil) {
        _style = StateObject(wrappedValue: style ?? .themed(ThemeManager.shared.currentThemeStyle))
        _viewModel = StateObject(wrappedValue: QuizViewModel(game: game))
        self.game = game
    }
    
    var body: some View {
            ZStack {
                style.backgroundColor.ignoresSafeArea()
                
                if viewModel.shouldShowEmptyView {
                    EmptyView()
                } else {
                    ZStack {  // Заменили VStack на ZStack для наложения контента
                        // Лоадер
                        VStack {
                            Text("Loading...")
                                .foregroundColor(style.questionTextColor)
                            ProgressView()
                        }
                        .opacity(viewModel.currentCard == nil ? 1 : 0)
                        .animation(.easeInOut(duration: 0.3), value: viewModel.currentCard == nil)
                        
                        // Карточка
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
                                            locale: locale,
                                            style: style,
                                            option: option,
                                            onSelect: { viewModel.handleAnswer(option) }
                                        )
                                    }
                                }
                            }
                            .padding()
                            .opacity(viewModel.currentCard != nil ? 1 : 0)
                            .animation(.easeInOut(duration: 0.3), value: viewModel.currentCard != nil)
                        }
                    }
                    .padding()
                }
            }
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
