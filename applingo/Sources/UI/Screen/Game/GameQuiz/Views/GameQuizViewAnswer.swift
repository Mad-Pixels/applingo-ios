import SwiftUI

internal struct GameQuizViewAnswer: View {
    @EnvironmentObject private var themeManager: ThemeManager

    @ObservedObject private var viewModel: QuizViewModel

    private let locale: GameQuizLocale
    private let style: GameQuizStyle
    private let card: QuizModelCard
    private let onSelect: (String) -> Void

    init(
        style: GameQuizStyle,
        locale: GameQuizLocale,
        card: QuizModelCard,
        onSelect: @escaping (String) -> Void,
        viewModel: QuizViewModel
    ) {
        self.card = card
        self.style = style
        self.locale = locale
        self.onSelect = onSelect
        self.viewModel = viewModel
    }

    var body: some View {
        if card.voice && card.flip && AppStorage.shared.useASR {
            GameQuizViewAnswerRecord(
                languageCode: card.word.backTextCode,
                onRecognized: { recognized in
                    onSelect(recognized)
                }
            )
            .opacity(viewModel.isProcessingAnswer ? 0.7 : 1.0)
            .disabled(viewModel.isProcessingAnswer)
            .padding(.horizontal, style.optionsPadding)
        } else {
            VStack(spacing: style.optionsSpacing) {
                ForEach(card.options, id: \.self) { option in
                    ButtonAction(
                        title: option,
                        action: {
                            guard !viewModel.isProcessingAnswer else { return }
                            onSelect(option)
                        },
                        style: getButtonStyle(for: option)
                    )
                    .opacity(viewModel.isProcessingAnswer && !viewModel.highlightedOptions.keys.contains(option) ? 0.7 : 1.0)
                    .disabled(viewModel.isProcessingAnswer)
                    .padding(.horizontal, style.optionsPadding)
                }
            }
        }
    }

    private func getButtonStyle(for option: String) -> ButtonActionStyle {
        if let highlightColor = viewModel.highlightedOptions[option] {
            return .GameAnswer(themeManager.currentThemeStyle, highlightColor: highlightColor)
        } else {
            return .game(themeManager.currentThemeStyle)
        }
    }
}
