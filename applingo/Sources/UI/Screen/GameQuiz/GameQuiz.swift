import SwiftUI

struct GameQuiz: View {
    @ObservedObject var game: Quiz
    @StateObject private var style: GameQuizStyle
    @StateObject private var locale = GameQuizLocale()
    @EnvironmentObject var cacheGetter: WordCache
    
    @State private var currentCard: QuizModelCard?
    
    init(game: Quiz, style: GameQuizStyle? = nil) {
        self.game = game
        let initialStyle = style ?? .themed(ThemeManager.shared.currentThemeStyle)
        _style = StateObject(wrappedValue: initialStyle)
    }
    
    private func generateCard() {
        let cache = cacheGetter.cache
        guard cache.count >= 4 else { return }
        
        // Получаем 4 уникальных слова
        var selectedWords: Set<DatabaseModelWord> = []
        var attempts = 0
        let maxAttempts = 20
        
        while selectedWords.count < 4 && attempts < maxAttempts {
            if let word = cache.randomElement() {
                // Проверяем уникальность frontText и backText
                let hasDuplicate = selectedWords.contains { existing in
                    existing.frontText == word.frontText ||
                    existing.frontText == word.backText ||
                    existing.backText == word.frontText ||
                    existing.backText == word.backText
                }
                
                if !hasDuplicate {
                    selectedWords.insert(word)
                }
            }
            attempts += 1
        }
        
        guard selectedWords.count == 4 else { return }
        
        let wordsArray = Array(selectedWords)
        let correctWord = wordsArray[0] // Можно рандомно выбирать
        let showingFront = Bool.random()
        
        currentCard = QuizModelCard(
            correctWord: correctWord,
            allWords: wordsArray,
            showingFront: showingFront
        )
        
        if let validation = game.validation as? QuizValidation {
            validation.setCurrentCard(currentCard!)
        }
    }
    
    private func handleAnswer(_ answer: String) {
        let result = game.validateAnswer(answer)
        game.updateStats(
            correct: result == .correct,
            responseTime: 0, // TODO: Добавить измерение времени
            isSpecialCard: false
        )
        
        // После небольшой задержки генерируем новую карточку
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            generateCard()
        }
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                if let card = currentCard {
                    Text(card.question)
                        .font(.title)
                        .padding()
                    
                    ForEach(card.options, id: \.self) { option in
                        Button(action: { handleAnswer(option) }) {
                            Text(option)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(10)
                        }
                    }
                } else {
                    Text("Loading...")
                }
            }
            .padding()
        }
        .onAppear {
            generateCard()
        }
    }
}
