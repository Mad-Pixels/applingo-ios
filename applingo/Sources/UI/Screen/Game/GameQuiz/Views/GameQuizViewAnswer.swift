import SwiftUI

internal struct GameQuizViewAnswer: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    @ObservedObject private var viewModel: QuizViewModel
    
    private let locale: GameQuizLocale
    private let style: GameQuizStyle
    private let card: QuizModelCard
    private let option: String
    private let onSelect: () -> Void
    
    init(
        style: GameQuizStyle,
        locale: GameQuizLocale,
        card: QuizModelCard,
        option: String,
        onSelect: @escaping () -> Void,
        viewModel: QuizViewModel
    ) {
        self.card = card
        self.style = style
        self.option = option
        self.locale = locale
        self.onSelect = onSelect
        self.viewModel = viewModel
    }
    
    var body: some View {
        if card.voice && card.flip {
            GameQuizViewAnswerRecord(
                languageCode: card.word.backTextCode,
                onRecognized: { recognized in
                    viewModel.handleAnswer(recognized)
                }
            )
            .opacity(viewModel.isProcessingAnswer ? 0.7 : 1.0)
            .disabled(viewModel.isProcessingAnswer)
            .padding(.horizontal, style.optionsPadding)
        } else {
            ButtonAction(
                title: option,
                action: {
                    guard !viewModel.isProcessingAnswer else { return }
                    onSelect()
                },
                style: getButtonStyle()
            )
            .opacity(viewModel.isProcessingAnswer && !viewModel.highlightedOptions.keys.contains(option) ? 0.7 : 1.0)
            .disabled(viewModel.isProcessingAnswer)
            .padding(.horizontal, style.optionsPadding)
        }
    }
    
    private func getButtonStyle() -> ButtonActionStyle {
        if let highlightColor = viewModel.highlightedOptions[option] {
            return .GameAnswer(themeManager.currentThemeStyle, highlightColor: highlightColor)
        } else {
            return .game(themeManager.currentThemeStyle)
        }
    }
}
