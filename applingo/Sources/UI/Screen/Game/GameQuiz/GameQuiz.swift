import SwiftUI

struct GameQuiz: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var style: GameQuizStyle
    @StateObject private var locale = GameQuizLocale()
    @StateObject private var viewModel: QuizViewModel
    
    @ObservedObject var game: Quiz
    @State private var isLoading = true
    @State private var shouldShowPreloader = false
    
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
                    .padding(.top, 36)
                                
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
            
            // Показываем прелоадер только если shouldShowPreloader == true
            if shouldShowPreloader {
                ItemListLoading(style: .themed(themeManager.currentThemeStyle))
            }
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    GameQuizViewActions(
                        style: style,
                        onAdd: { }
                    )
                    .padding(.bottom, 32)
                    .padding(.trailing, 16)
                    .opacity(isLoading ? 0 : 1)
                }
            }
        }
        .padding()
        .onAppear {
            isLoading = true
            shouldShowPreloader = false
            
            // Начинаем загрузку
            viewModel.generateCard()
            
            // Проверяем через 0.2 сек, всё ли загрузилось
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                // Если всё ещё идёт загрузка, показываем прелоадер
                if isLoading {
                    shouldShowPreloader = true
                }
            }
            
            // В любом случае скрываем прелоадер и завершаем загрузку через 0.8 сек
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                shouldShowPreloader = false
                isLoading = false
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
