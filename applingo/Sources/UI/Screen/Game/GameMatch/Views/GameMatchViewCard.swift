import SwiftUI

internal struct GameMatchViewCard: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    @ObservedObject private var viewModel: GameMatchViewModel
    
    private let text: String
    private let index: Int
    private let onSelect: () -> Void
    private let isSelected: Bool
    private let isMatched: Bool
    
    // Добавляем состояние для анимации исчезновения
    @State private var isVisible = true
    
    init(
        text: String,
        index: Int,
        onSelect: @escaping () -> Void,
        isSelected: Bool,
        isMatched: Bool,
        viewModel: GameMatchViewModel
    ) {
        self.text = text
        self.index = index
        self.onSelect = onSelect
        self.isSelected = isSelected
        self.isMatched = isMatched
        self.viewModel = viewModel
    }
    
    var body: some View {
        ButtonAction(
            title: text,
            action: {
                guard !viewModel.isLoadingCard else { return }
                onSelect()
            },
            style: getButtonStyle()
        )
        .opacity(viewModel.isCardUpdating(index: index) ? 0 : (isMatched ? 0 : 1.0)) // Делаем невидимыми карточки, которые обновляются или уже сопоставлены
        .scaleEffect(isMatched ? 0.8 : 1.0) // Уменьшаем размер сопоставленных карточек
        .animation(.easeInOut(duration: 0.3), value: isMatched) // Добавляем анимацию
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
    
    private func getButtonStyle() -> ButtonActionStyle {
        if let highlightColor = viewModel.highlightedOptions[text] {
            return .GameAnswer(themeManager.currentThemeStyle, highlightColor: highlightColor)
        } else if isMatched {
            // Стиль для совпавших карточек с эффектом исчезновения
            return createMatchedStyle()
        } else if isSelected {
            // Стиль для выбранных карточек
            return createSelectedStyle()
        } else {
            // Стандартный стиль
            return .gameCompact(themeManager.currentThemeStyle)
        }
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
        //style.foregroundColor = .clear // Делаем текст невидимым
        return style
    }
}
