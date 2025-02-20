import SwiftUI

/// Представление для игры «Match» с 16 кнопками (2 ряда по 8),
/// где в первом ряду отображаются frontText, а во втором — backText.
struct GameMatch: View {
    @StateObject private var viewModel = MatchGameViewModel()
    /// Ожидается, что игра типа Match реализует метод getItems(_:) и возвращает [DatabaseModelWord]
    @ObservedObject var game: Match
    @ObservedObject private var cache: MatchCache
    
    init(game: Match) {
        self.game = game
        self.cache = game.cache
    }
    
    var body: some View {
        VStack(spacing: 16) {
            
            // Первый ряд – frontText
            HStack(spacing: 4) {
                ForEach(viewModel.frontItems, id: \.id) { word in
                    Button(action: {
                        viewModel.selectFront(word)
                    }) {
                        Text(word.frontText)
                            .frame(maxWidth: .infinity)
                            .padding(8)
                            .background(viewModel.selectedFront?.id == word.id ? Color.blue.opacity(0.5) : Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
            }
            
            // Второй ряд – backText
            HStack(spacing: 4) {
                ForEach(viewModel.backItems, id: \.id) { word in
                    Button(action: {
                        viewModel.selectBack(word)
                    }) {
                        Text(word.backText)
                            .frame(maxWidth: .infinity)
                            .padding(8)
                            .background(viewModel.selectedBack?.id == word.id ? Color.green.opacity(0.5) : Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
            }
        }
        .padding()
        .onAppear {
            loadNewWords()
        }
        // Если набор слов закончился, автоматически подгружаем новые
        .onChange(of: cache.cache.count) { newCount in
            Logger.debug("[GameMatch]: Cache size changed", metadata: [
                "newCount": String(newCount)
            ])
            if newCount > 0 {
                loadNewWords()
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
        
        // Убираем проверку на count == 8
        if !words.isEmpty {
            viewModel.setupGame(with: words)
            Logger.debug("[GameMatch]: Setup game with words")
        }
    }
}
