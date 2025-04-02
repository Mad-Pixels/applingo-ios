import SwiftUI

internal struct GameMatchViewCard: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    @ObservedObject private var viewModel: GameMatchViewModel
    
    private let style: GameTheme
    private let text: String
    private let index: Int
    private let isFrontCard: Bool
    private let onSelect: () -> Void
    
    init(
        style: GameTheme,
        text: String,
        index: Int,
        isFrontCard: Bool,
        onSelect: @escaping () -> Void,
        viewModel: GameMatchViewModel
    ) {
        self.style = style
        self.text = text
        self.index = index
        self.isFrontCard = isFrontCard
        self.onSelect = onSelect
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
        .opacity(viewModel.isLoadingCard ? 0.7 : 1.0)
        .disabled(isMatched() || viewModel.isLoadingCard)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
    }
    
    private func getButtonStyle() -> ButtonActionStyle {
        if isMatched() {
            // Стиль для совпавших карточек
            return createMatchedStyle()
        } else if isSelected() {
            // Стиль для выбранных карточек
            return createSelectedStyle()
        } else {
            // Стандартный стиль
            return .game(themeManager.currentThemeStyle)
        }
    }
    
    // Проверяет, выбрана ли карточка
    private func isSelected() -> Bool {
        if isFrontCard {
            return viewModel.selectedFrontIndex == index
        } else {
            return viewModel.selectedBackIndex == index
        }
    }
    
    // Проверяет, совпала ли карточка
    private func isMatched() -> Bool {
        return viewModel.matchedIndices.contains(index)
    }
    
    // Создает стиль для выбранной карточки
    private func createSelectedStyle() -> ButtonActionStyle {
        var style = ButtonActionStyle.game(themeManager.currentThemeStyle)
        style.backgroundColor = themeManager.currentThemeStyle.accentPrimary.opacity(0.7)
        return style
    }
    
    // Создает стиль для совпавшей карточки
    private func createMatchedStyle() -> ButtonActionStyle {
        var style = ButtonActionStyle.game(themeManager.currentThemeStyle)
        style.backgroundColor = Color.gray.opacity(0.5)
        return style
    }
}
