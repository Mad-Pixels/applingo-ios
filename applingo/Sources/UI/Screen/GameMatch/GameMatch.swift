import SwiftUI

/// Представление для игры «Match» с 16 кнопками (2 ряда по 8),
/// где в первом ряду отображаются frontText, а во втором — backText.
struct GameMatch: View {
    @StateObject private var viewModel: MatchGameViewModel
    @ObservedObject var game: Match
    @ObservedObject private var cache: MatchCache
    @EnvironmentObject private var themeManager: ThemeManager
    
    init(game: Match) {
        self.game = game
        self._viewModel = StateObject(wrappedValue: MatchGameViewModel(game: game))
        self.cache = game.cache
    }
    
    var body: some View {
        HStack(spacing: 0) {
            // Первый ряд – frontText
            if !viewModel.frontItems.isEmpty {  // Добавим проверку
                VStack(spacing: 4) {
                    ForEach(viewModel.frontItems, id: \.id) { word in
                        GameMatchButton(
                            text: word.frontText,
                            action: {
                                viewModel.selectFront(word)
                            },
                            isSelected: viewModel.selectedFront?.id == word.id,
                            isMatched: viewModel.matchedPairs.contains(word.id ?? 0)
                        )
                    }
                }
                .padding(.horizontal)
            }
            
            // Контейнер для разделителя
            ZStack {
                // Разделитель (70% высоты)
                Rectangle()
                    .fill(Color.gray.opacity(0.5))
                    .frame(width: 1)
                    .scaleEffect(y: 0.7) // Масштабируем только по высоте до 70%
            }
            .frame(width: 20) // Резервируем место для разделителя
            
            // Второй ряд – backText
            if !viewModel.backItems.isEmpty {  // Добавим проверку
                VStack(spacing: 4) {
                    ForEach(viewModel.backItems, id: \.id) { word in
                        GameMatchButton(
                            text: word.backText,
                            action: {
                                viewModel.selectBack(word)
                            },
                            isSelected: viewModel.selectedBack?.id == word.id,
                            isMatched: viewModel.matchedPairs.contains(word.id ?? 0)
                        )
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.top, 36)
        .onAppear {
            loadNewWords()
        }
        .onChange(of: cache.cache.count) { count in
            // Если кэш заполнился и у нас нет слов - пробуем загрузить
            if count > 0 && viewModel.frontItems.isEmpty {
                loadNewWords()
            }
        }
        .onChange(of: viewModel.matchedPairs.count) { count in
            if count >= viewModel.replaceThreshold {  // Используем новый порог
                replaceMatchedWords()
            }
        }
    }
    
    private func loadNewWords() {
        Logger.debug("[GameMatch]: Loading new words")
        
        guard let words = game.getItems(8) as? [DatabaseModelWord] else {
            Logger.debug("[GameMatch]: Failed to get words")
            return
        }
        
        Logger.debug("[GameMatch]: Got words", metadata: [
            "count": String(words.count)
        ])
        
        if !words.isEmpty {
            // Удаляем слова из кэша после того как убедились что они есть
            words.forEach { game.removeItem($0) }
            viewModel.setupGame(with: words)
            Logger.debug("[GameMatch]: Setup game with words")
        }
    }
    
    private func replaceMatchedWords() {
        Logger.debug("[GameMatch]: Replacing matched words")
        
        // Запрашиваем больше слов, чтобы гарантировать maxWords после фильтрации
        let requestCount = viewModel.maxWords
        
        guard let newWords = game.getItems(requestCount) as? [DatabaseModelWord] else {
            Logger.debug("[GameMatch]: Failed to get replacement words")
            return
        }
        
        // Удаляем новые слова из кэша
        newWords.forEach { game.removeItem($0) }
        
        viewModel.addNewWords(newWords)
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
            return .gameAnswer(themeManager.currentThemeStyle)
        }
    }
    
    // Создаем стиль для выбранных слов (выделенных)
    private func createSelectedStyle() -> ButtonActionStyle {
        var style = ButtonActionStyle.gameAnswer(themeManager.currentThemeStyle)
        // Изменяем цвет фона для выделения
        style.backgroundColor = themeManager.currentThemeStyle.accentPrimary.opacity(0.7)
        return style
    }
    
    // Создаем стиль для совпавших слов (уже найденных пар)
    private func createMatchedStyle() -> ButtonActionStyle {
        var style = ButtonActionStyle.gameAnswer(themeManager.currentThemeStyle)
        // Изменяем цвет фона для совпавших слов
        style.backgroundColor = Color.gray.opacity(0.5)
        return style
    }
}
