import SwiftUI

struct GameQuizViewAnswer: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    private let locale: GameQuizLocale
    private let style: GameQuizStyle
    private let option: String
    private let onSelect: () -> Void
    private let viewModel: QuizViewModel
    
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
            action: onSelect,
            style: getButtonStyle()
        )
    }
    
    private func getButtonStyle() -> ButtonActionStyle {
        if let highlightColor = viewModel.highlightedOptions[option] {
            return .incorrectGameAnswer(themeManager.currentThemeStyle, highlightColor: highlightColor)
        } else {
            return .gameAnswer(themeManager.currentThemeStyle)
        }
    }
}
