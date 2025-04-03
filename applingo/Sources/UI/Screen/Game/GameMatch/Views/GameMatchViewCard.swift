import SwiftUI

internal struct GameMatchViewCard: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    @ObservedObject private var viewModel: GameMatchViewModel
    
    private let text: String
    private let index: Int
    private let onSelect: () -> Void
    private let isSelected: Bool
    private let isMatched: Bool
    private let isQuestion: Bool // Добавляем флаг для определения стороны карточки
    
    // Добавляем состояние для анимации исчезновения
    @State private var isVisible = true
    
    init(
        text: String,
        index: Int,
        onSelect: @escaping () -> Void,
        isSelected: Bool,
        isMatched: Bool,
        viewModel: GameMatchViewModel,
        isQuestion: Bool = true // По умолчанию считаем, что это вопрос
    ) {
        self.text = text
        self.index = index
        self.onSelect = onSelect
        self.isSelected = isSelected
        self.isMatched = isMatched
        self.viewModel = viewModel
        self.isQuestion = isQuestion
    }
    
    var body: some View {
        // Используем метод из ViewModel для получения текста с учетом кэша
        let displayText = viewModel.getCardText(index: index, isQuestion: isQuestion)
        
        ButtonAction(
            title: displayText, // Используем текст из кэша или текущей карточки
            action: {
                guard !viewModel.isLoadingCard else { return }
                onSelect()
            },
            style: getButtonStyle(for: displayText) // Передаем новый текст в метод стиля
        )
        .opacity(viewModel.isCardUpdating(index: index) ? 0 : (isMatched ? 0 : 1.0))
        .scaleEffect(isMatched ? 0.8 : 1.0)
        .animation(.easeInOut(duration: 0.3), value: isMatched)
        .disabled(isMatched || viewModel.isLoadingCard || viewModel.isCardUpdating(index: index))
        .onChange(of: isMatched) { newValue in
            if newValue {
                // Задержка для эффекта исчезновения
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    withAnimation(.easeOut(duration: 0.3)) {
                        isVisible = false
                    }
                }
            } else {
                isVisible = true
            }
        }
    }
    
    private func getButtonStyle(for text: String) -> ButtonActionStyle {
//        if let highlightColor = viewModel.highlightedOptions[text] {
//            return .GameAnswer(themeManager.currentThemeStyle, highlightColor: highlightColor)
//        } else if isMatched {
//            // Стиль для совпавших карточек с эффектом исчезновения
//            return createMatchedStyle()
//        } else if isSelected {
//            // Стиль для выбранных карточек
//            return createSelectedStyle()
//        } else {
//            // Стандартный стиль
//            return .gameCompact(themeManager.currentThemeStyle)
//        }
        return .gameCompact(themeManager.currentThemeStyle)
    }
    
    // Создает стиль для выбранной карточки
    private func createSelectedStyle() -> ButtonActionStyle {
        var style = ButtonActionStyle.game(themeManager.currentThemeStyle)
        style.backgroundColor = themeManager.currentThemeStyle.accentPrimary.opacity(0.7)
        return style
    }
    
    private func createMatchedStyle() -> ButtonActionStyle {
        var style = ButtonActionStyle.game(themeManager.currentThemeStyle)
        style.backgroundColor = themeManager.currentThemeStyle.matchTheme.correct.opacity(0.5)
        return style
    }
}
