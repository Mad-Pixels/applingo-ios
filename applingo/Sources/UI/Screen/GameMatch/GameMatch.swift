import SwiftUI

/// Представление для игры «Match» с 16 кнопками (2 ряда по 8),
/// где в первом ряду отображаются frontText, а во втором — backText.
struct GameMatch: View {
    @StateObject private var viewModel: MatchGameViewModel
        @ObservedObject var game: Match
        @ObservedObject private var cache: MatchCache
        
        init(game: Match) {
            self.game = game
            self._viewModel = StateObject(wrappedValue: MatchGameViewModel(game: game))
            self.cache = game.cache
        }
    
    var body: some View {
        HStack(spacing: 16) {
            // Первый ряд – frontText
            if !viewModel.frontItems.isEmpty {  // Добавим проверку
                            VStack(spacing: 4) {
                                ForEach(viewModel.frontItems, id: \.id) { word in
                                    Button(action: {
                                        viewModel.selectFront(word)
                                    }) {
                                        Text(word.frontText)
                                            .frame(maxWidth: .infinity)
                                            .padding(8)
                                            .background(getButtonBackground(for: word, isSelected: viewModel.selectedFront?.id == word.id))
                                            .foregroundColor(.white)
                                            .cornerRadius(8)
                                    }
                                    .disabled(viewModel.matchedPairs.contains(word.id ?? 0))
                                }
                            }
                        }
            
            // Второй ряд – backText
            if !viewModel.backItems.isEmpty {  // Добавим проверку
                            VStack(spacing: 4) {
                                ForEach(viewModel.backItems, id: \.id) { word in
                                    Button(action: {
                                        viewModel.selectBack(word)
                                    }) {
                                        Text(word.backText)
                                            .frame(maxWidth: .infinity)
                                            .padding(8)
                                            .background(getButtonBackground(for: word, isSelected: viewModel.selectedBack?.id == word.id))
                                            .foregroundColor(.white)
                                            .cornerRadius(8)
                                    }
                                    .disabled(viewModel.matchedPairs.contains(word.id ?? 0))
                                }
                            }
                        }
        }
        .padding()
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
    
    private func getButtonBackground(for word: DatabaseModelWord, isSelected: Bool) -> Color {
        if viewModel.matchedPairs.contains(word.id ?? 0) {
            return .gray
        }
        return isSelected ? .blue.opacity(0.5) : .blue
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
