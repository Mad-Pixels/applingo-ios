import SwiftUI

/// A view that presents a quiz game interface by generating quiz cards from a word cache and handling user answers.
///
/// The `GameQuiz` view uses a dedicated view model (`QuizViewModel`) to encapsulate the logic for generating quiz cards
/// and processing user responses. It observes the state of the underlying quiz game model (`Quiz`) to react to changes such as
/// cache loading and game over conditions. When a new card is generated, it displays the question and options,
/// and upon the user selecting an answer, the view model processes the answer, updates game statistics, and eventually
/// generates a new quiz card. If the game state indicates that the game is over, the view dismisses itself.
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
    
    /// Initializes the `GameQuiz` view with the given quiz game model and an optional style configuration.
    ///
    /// - Parameters:
    ///   - game: The quiz game model containing the game logic, state, and cache.
    ///   - style: An optional style configuration; if nil, a default themed style is applied.
    init(game: Quiz, style: GameQuizStyle? = nil) {
        _style = StateObject(wrappedValue: style ?? .themed(ThemeManager.shared.currentThemeStyle))
        _viewModel = StateObject(wrappedValue: QuizViewModel(game: game))
        self.game = game
    }
    
    var body: some View {
            ZStack {
                style.backgroundColor.ignoresSafeArea()
                
                
                VStack(spacing: 20) {
                    if let card = viewModel.currentCard {
                        VStack(spacing: style.optionsSpacing) {
                            // Question Card
                            Text(card.question)
                                .font(style.questionFont)
                                .foregroundColor(style.questionTextColor)
                                .multilineTextAlignment(.center)
                                .padding(style.cardPadding)
                                .frame(maxWidth: .infinity)
                                .background(style.cardBackground)
                                .cornerRadius(style.cardCornerRadius)
                                .overlay(
                                    RoundedRectangle(cornerRadius: style.cardCornerRadius)
                                        .stroke(style.cardBorder, lineWidth: 1)
                                )
                                .shadow(radius: style.cardShadowRadius)
                            
                            // Options
                            VStack(spacing: style.optionsSpacing) {
                                ForEach(card.options, id: \.self) { option in
                                    Button(action: { viewModel.handleAnswer(option) }) {
                                        Text(option)
                                            .font(style.optionFont)
                                            .foregroundColor(style.optionTextColor)
                                            .padding(style.optionsPadding)
                                            .frame(maxWidth: .infinity)
                                            .background(style.optionBackground)
                                            .cornerRadius(style.optionCornerRadius)
                                            .shadow(radius: style.optionShadowRadius)
                                    }
                                    .buttonStyle(QuizOptionButtonStyle(pressedBackground: style.optionBackgroundPressed))
                                }
                            }
                        }
                        .padding()
                    } else {
                        Text(verbatim: "Loading...")
                            .foregroundColor(style.questionTextColor)
                        if game.isLoadingCache {
                            ProgressView()
                        }
                    }
                }
                .padding()
            }
        .onAppear {
            viewModel.generateCard()
        }
        .onReceive(game.$isLoadingCache) { isLoading in
            if !isLoading && viewModel.currentCard == nil {
                viewModel.generateCard()
            }
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

struct QuizOptionButtonStyle: ButtonStyle {
    let pressedBackground: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(configuration.isPressed ? pressedBackground : Color.clear)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}
