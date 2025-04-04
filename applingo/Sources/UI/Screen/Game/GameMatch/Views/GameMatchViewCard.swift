import SwiftUI

internal struct GameMatchViewCard: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    @ObservedObject private var viewModel: GameMatchViewModel
    
    private let text: String
    private let boardPosition: Int
    private let cardIndex: Int
    private let onSelect: () -> Void
    private let isSelected: Bool
    private let isMatched: Bool
    private let isQuestion: Bool
    
    @State private var isVisible = true
    
    init(
        text: String,
        boardPosition: Int,
        cardIndex: Int,
        onSelect: @escaping () -> Void,
        isSelected: Bool,
        isMatched: Bool,
        viewModel: GameMatchViewModel,
        isQuestion: Bool = true
    ) {
        self.text = text
        self.boardPosition = boardPosition
        self.cardIndex = cardIndex
        self.onSelect = onSelect
        self.isSelected = isSelected
        self.isMatched = isMatched
        self.viewModel = viewModel
        self.isQuestion = isQuestion
    }
    
    var body: some View {
        ButtonAction(
            title: text,
            action: {
                guard !viewModel.isLoadingCard else { return }
                onSelect()
            },
            style: getButtonStyle(for: text)
        )
        .opacity(isMatched ? 0 : 1.0)
        .scaleEffect(isMatched ? 0.8 : 1.0)
        .animation(.easeInOut(duration: 0.3), value: isMatched)
        .disabled(isMatched || viewModel.isLoadingCard)
        .onChange(of: isMatched) { newValue in
            if newValue {
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
        if viewModel.highlightedOptions[text] != nil {
            // Приоритет визуального фидбека выше, чем обычного выбора
            return ButtonActionStyle.GameAnswer(themeManager.currentThemeStyle, highlightColor: viewModel.highlightedOptions[text]!)
        } else if isSelected {
            return createSelectedStyle()
        } else if isMatched {
            return createMatchedStyle()
        } else {
            return .gameCompact(themeManager.currentThemeStyle)
        }
    }
    
    private func createSelectedStyle() -> ButtonActionStyle {
        var style = ButtonActionStyle.game(themeManager.currentThemeStyle)
        style.backgroundColor = themeManager.currentThemeStyle.accentLight
        return style
    }
    
    private func createMatchedStyle() -> ButtonActionStyle {
        var style = ButtonActionStyle.game(themeManager.currentThemeStyle)
        style.backgroundColor = themeManager.currentThemeStyle.matchTheme.correct.opacity(0.5)
        return style
    }
}
