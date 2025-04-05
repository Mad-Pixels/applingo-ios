import SwiftUI

struct GameQuiz: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var viewModel: QuizViewModel
    @StateObject private var locale = GameQuizLocale()
    @StateObject private var style: GameQuizStyle
    
    @ObservedObject var game: Quiz
    
    @State private var shouldShowPreloader = false
    @State private var preloaderTimer: DispatchWorkItem?
    
    init(
        game: Quiz,
        style: GameQuizStyle = .themed(ThemeManager.shared.currentThemeStyle)
    ) {
        let vm = QuizViewModel(game: game)
        _viewModel = StateObject(wrappedValue: vm)
        _style = StateObject(wrappedValue: style)
        self.game = game
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if shouldShowPreloader {
                    ItemListLoading(style: .themed(themeManager.currentThemeStyle))
                }
                
                if let card = viewModel.currentCard {
                    VStack(spacing: 0) {
                        VStack(spacing: style.optionsSpacing) {
                            GameQuizViewQuestion(
                                locale: locale,
                                style: style,
                                card: card
                            )
                            .padding(.vertical, style.optionsSpacing)

                            GameQuizViewAnswer(
                                style: style,
                                locale: locale,
                                card: card,
                                onSelect: { viewModel.handleAnswer($0) },
                                viewModel: viewModel
                            )
                        }
                        .padding(.horizontal)
                        .padding(.top, geometry.size.height * 0.03)
                        .frame(
                            minHeight: geometry.size.height * 0.7,
                            alignment: .center
                        )
                    }

                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            GameFloatingBtnSpeaker(word: card.word)
                                .padding(.bottom, 32)
                        }
                    }
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .onAppear {
            viewModel.generateCard()
        }
        .onChange(of: viewModel.isLoadingCard) { isLoading in
            handleLoadingStateChange(isLoading)
        }
        .onReceive(game.state.$isGameOver) { isGameOver in
            if isGameOver {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    dismiss()
                }
            }
        }
    }
    
    private func handleLoadingStateChange(_ isLoading: Bool) {
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
}
