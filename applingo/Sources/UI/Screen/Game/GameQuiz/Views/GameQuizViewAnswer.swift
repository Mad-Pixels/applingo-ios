import SwiftUI

internal struct GameQuizViewAnswer: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    @ObservedObject private var viewModel: QuizViewModel
    
    private let locale: GameQuizLocale
    private let style: GameQuizStyle
    private let option: String
    private let onSelect: () -> Void
    
    init(
        style: GameQuizStyle,
        locale: GameQuizLocale,
        option: String,
        onSelect: @escaping () -> Void,
        viewModel: QuizViewModel
    ) {
        self.style = style
        self.option = option
        self.locale = locale
        self.onSelect = onSelect
        self.viewModel = viewModel
    }
    
    var body: some View {
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
    }
    
    private func getButtonStyle() -> ButtonActionStyle {
        if let highlightColor = viewModel.highlightedOptions[option] {
            return .GameAnswer(themeManager.currentThemeStyle, highlightColor: highlightColor)
        } else {
            return .game(themeManager.currentThemeStyle)
        }
    }
}
