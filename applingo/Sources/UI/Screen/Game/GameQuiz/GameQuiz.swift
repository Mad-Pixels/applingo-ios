import SwiftUI

struct GameQuiz: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var style: GameQuizStyle
    @StateObject private var locale = GameQuizLocale()
    @StateObject private var viewModel: QuizViewModel
    
    @ObservedObject var game: Quiz
    @State private var shouldShowPreloader = false
    @State private var preloaderTimer: DispatchWorkItem?
    
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
            
            if shouldShowPreloader {
                ItemListLoading(style: .themed(themeManager.currentThemeStyle))
            }
            
            if let card = viewModel.currentCard {
                VStack {
                    VStack(spacing: style.optionsSpacing) {
                        GameQuizViewQuestion(
                            locale: locale,
                            style: style,
                            question: card.question
                        )
                        .padding(.vertical, style.optionsSpacing)
                        
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
                    .padding(.top, 128)
                    
                    Spacer()
                    
                    ButtonFloatingSingle(
                        icon: "volume",
                        action: {}
                    )
                    .padding(.bottom, 32)
                    .padding(.horizontal, 8)
                }
            }
        }
        .onAppear {
            viewModel.generateCard()
        }
        .onChange(of: viewModel.isLoadingCard) { isLoading in
            if isLoading {
                preloaderTimer?.cancel()
                
                let timer = DispatchWorkItem {
                    if viewModel.isLoadingCard {
                        shouldShowPreloader = true
                    }
                }
                preloaderTimer = timer
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: timer)
            } else {
                preloaderTimer?.cancel()
                preloaderTimer = nil
                
                shouldShowPreloader = false
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
