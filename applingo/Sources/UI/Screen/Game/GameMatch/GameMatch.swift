import SwiftUI

/// Представление для игры «Match» с 16 кнопками (2 ряда по 8),
/// где в первом ряду отображаются frontText, а во втором — backText.
struct GameMatch: View {
    @StateObject private var viewModel: MatchGameViewModel
    @ObservedObject var game: Match
    @ObservedObject private var cache: MatchCache
    @EnvironmentObject private var themeManager: ThemeManager
    
    @State private var shouldShowPreloader = false
    @State private var preloaderTimer: DispatchWorkItem?
    
    init(game: Match) {
        self.game = game
        self._viewModel = StateObject(wrappedValue: MatchGameViewModel(game: game))
        self.cache = game.cache
    }
    
    var body: some View {
        ZStack {
            if shouldShowPreloader {
                ItemListLoading(style: .themed(themeManager.currentThemeStyle))
            }
            
            if !viewModel.currentCards.isEmpty {
                HStack(spacing: 0) {
                    // Первый ряд – frontText (вопросы)
                    VStack(spacing: 4) {
                        ForEach(0..<viewModel.currentCards.count, id: \.self) { index in
                            GameMatchButton(
                                text: viewModel.currentCards[index].question,
                                action: {
                                    viewModel.selectFront(at: index)
                                },
                                isSelected: viewModel.selectedFrontIndex == index,
                                isMatched: viewModel.matchedIndices.contains(index)
                            )
                        }
                    }
                    .padding(.horizontal)
                    
                    // Контейнер для разделителя
                    ZStack {
                        // Разделитель (70% высоты)
                        Rectangle()
                            .fill(Color.gray.opacity(0.5))
                            .frame(width: 1)
                            .scaleEffect(y: 0.7) // Масштабируем только по высоте до 70%
                    }
                    .frame(width: 20) // Резервируем место для разделителя
                    
                    // Второй ряд – backText (ответы)
                    VStack(spacing: 4) {
                        ForEach(0..<viewModel.currentCards.count, id: \.self) { index in
                            GameMatchButton(
                                text: viewModel.currentCards[index].answer,
                                action: {
                                    viewModel.selectBack(at: index)
                                },
                                isSelected: viewModel.selectedBackIndex == index,
                                isMatched: viewModel.matchedIndices.contains(index)
                            )
                        }
                    }
                    .padding(.horizontal)
                }
            } else if viewModel.shouldShowEmptyView {
                Text("Недостаточно слов для игры")
                    .foregroundColor(.gray)
            }
        }
        .padding(.top, 36)
        .onAppear {
            viewModel.generateCards()
        }
        .onChange(of: cache.cache.count) { count in
            // Если кэш заполнился и у нас нет карточек - пробуем загрузить
            if count > 0 && viewModel.currentCards.isEmpty {
                viewModel.generateCards()
            }
        }
        .onChange(of: viewModel.isLoadingCard) { isLoading in
            if isLoading {
                preloaderTimer?.cancel()
                
                let timer = DispatchWorkItem {
                    if viewModel.isLoadingCard {
                        shouldShowPreloader = true
                    }
                }
                
                preloaderTimer = timer
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: timer)
            } else {
                preloaderTimer?.cancel()
                preloaderTimer = nil
                
                shouldShowPreloader = false
            }
        }
        .onReceive(game.state.$isGameOver) { isGameOver in
            if isGameOver {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    // Обработка завершения игры, если необходимо
                }
            }
        }
    }
}

/// Кнопка для игры Match, использующая ButtonAction
struct GameMatchButton: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    let text: String
    let action: () -> Void
    let isSelected: Bool
    let isMatched: Bool
    
    var body: some View {
        ButtonAction(
            title: text,
            action: action,
            disabled: isMatched,
            style: getButtonStyle()
        )
    }
    
    private func getButtonStyle() -> ButtonActionStyle {
        if isMatched {
            // Стиль для совпавших слов
            return createMatchedStyle()
        } else if isSelected {
            // Стиль для выбранных слов
            return createSelectedStyle()
        } else {
            // Стандартный стиль для активных слов
            return .game(themeManager.currentThemeStyle)
        }
    }
    
    // Создаем стиль для выбранных слов (выделенных)
    private func createSelectedStyle() -> ButtonActionStyle {
        var style = ButtonActionStyle.game(themeManager.currentThemeStyle)
        // Изменяем цвет фона для выделения
        style.backgroundColor = themeManager.currentThemeStyle.accentPrimary.opacity(0.7)
        return style
    }
    
    // Создаем стиль для совпавших слов (уже найденных пар)
    private func createMatchedStyle() -> ButtonActionStyle {
        var style = ButtonActionStyle.game(themeManager.currentThemeStyle)
        // Изменяем цвет фона для совпавших слов
        style.backgroundColor = Color.gray.opacity(0.5)
        return style
    }
}
