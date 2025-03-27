import SwiftUI

struct GameQuizViewAnswer: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    private let locale: GameQuizLocale
    private let style: GameQuizStyle
    private let option: String
    private let onSelect: () -> Void
    @ObservedObject private var viewModel: QuizViewModel
    
    init(locale: GameQuizLocale, style: GameQuizStyle, option: String, onSelect: @escaping () -> Void, viewModel: QuizViewModel) {
        self.locale = locale
        self.style = style
        self.option = option
        self.onSelect = onSelect
        self.viewModel = viewModel
    }
    
    var body: some View {
        ButtonAction(
            title: option,
            action: {
                // Блокируем повторные нажатия во время обработки ответа
                guard !viewModel.isProcessingAnswer else { return }
                onSelect()
            },
            style: getButtonStyle()
        )
        // Добавляем визуальную индикацию блокировки
        .opacity(viewModel.isProcessingAnswer && !viewModel.highlightedOptions.keys.contains(option) ? 0.7 : 1.0)
        // Полностью отключаем кнопку, когда идет обработка ответа
        .disabled(viewModel.isProcessingAnswer)
    }
    
    private func getButtonStyle() -> ButtonActionStyle {
        if let highlightColor = viewModel.highlightedOptions[option] {
            return .incorrectGameAnswer(themeManager.currentThemeStyle, highlightColor: highlightColor)
        } else {
            return .gameAnswer(themeManager.currentThemeStyle)
        }
    }
}
