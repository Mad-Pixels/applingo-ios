import SwiftUI

internal struct GameMatchViewCard: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    @ObservedObject private var viewModel: GameMatchViewModel
    
    private let text: String
    private let index: Int
    private let onSelect: () -> Void
    private let isSelected: Bool
    private let isMatched: Bool
    
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
        .opacity(viewModel.isLoadingCard ? 0.7 : 1.0)
        .disabled(isMatched || viewModel.isLoadingCard)
    }
    
    private func getButtonStyle() -> ButtonActionStyle {
        if let highlightColor = viewModel.highlightedOptions[text] {
            return .GameAnswer(themeManager.currentThemeStyle, highlightColor: highlightColor)
        } else if isMatched {
            // Стиль для совпавших карточек
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
    
    // Создает стиль для совпавшей карточки
    private func createMatchedStyle() -> ButtonActionStyle {
        var style = ButtonActionStyle.game(themeManager.currentThemeStyle)
        style.backgroundColor = Color.gray.opacity(0.5)
        return style
    }
}
