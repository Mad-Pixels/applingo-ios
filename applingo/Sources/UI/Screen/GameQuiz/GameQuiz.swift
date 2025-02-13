import SwiftUI

/// A view that presents a quiz game interface.
/// It generates quiz cards based on a word cache and handles user answers.
struct GameQuiz: View {
    
    // MARK: - Properties
    
    @ObservedObject var game: Quiz
    @StateObject private var style: GameQuizStyle
    @StateObject private var locale = GameQuizLocale()
    @EnvironmentObject var cacheGetter: WordCache
    @State private var currentCard: QuizModelCard?
    @State private var cardStartTime: Date?
    
    // MARK: - Initializer
    
    /// Initializes the GameQuiz view.
    /// - Parameters:
    ///   - game: The quiz game model.
    ///   - style: Optional style configuration; if nil, a themed style is applied.
    init(game: Quiz, style: GameQuizStyle? = nil) {
        self.game = game
        let initialStyle = style ?? .themed(ThemeManager.shared.currentThemeStyle)
        _style = StateObject(wrappedValue: initialStyle)
    }
    
    // MARK: - Methods
    
    /// Generates a new quiz card using random words from the cache.
    /// The method ensures that four unique words are selected based on their front/back texts.
    private func generateCard() {
        let cache = cacheGetter.cache
        Logger.debug("[Quiz]: Attempting to generate card", metadata: [
            "cacheCount": String(cache.count),
            "hasCurrentCard": String(currentCard != nil)
        ])
        
        guard cache.count >= 4 else {
            Logger.debug("[Quiz]: Not enough words in cache")
            cacheGetter.initializeCache()
            return
        }
        
        // Группируем слова по языковым группам
        let groupedWords = Dictionary(grouping: cache) { $0.subcategory }
        
        // Находим группу с достаточным количеством слов
        guard let (subcategory, words) = groupedWords.first(where: { $0.value.count >= 4 }) else {
            Logger.debug("[Quiz]: No language group has enough words")
            cacheGetter.initializeCache()
            return
        }
        
        Logger.debug("[Quiz]: Using language group", metadata: [
            "subcategory": subcategory,
            "availableWords": String(words.count)
        ])
        
        // Выбираем 4 случайных слова из одной языковой группы
        var selectedWords: Set<DatabaseModelWord> = []
        var attempts = 0
        let maxAttempts = 20
        
        while selectedWords.count < 4 && attempts < maxAttempts {
            if let word = words.randomElement() {
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
        
        guard selectedWords.count == 4 else {
            Logger.debug("[Quiz]: Failed to select unique words")
            return
        }
        
        let wordsArray = Array(selectedWords)
        let correctWord = wordsArray[0]
        let showingFront = Bool.random()
        
        cacheGetter.removeFromCache(correctWord)
        
        currentCard = QuizModelCard(
            correctWord: correctWord,
            allWords: wordsArray,
            showingFront: showingFront
        )
        
        if let validation = game.validation as? QuizValidation,
           let card = currentCard {
            validation.setCurrentCard(card)
        }
        
        cardStartTime = Date()
        
        Logger.debug("[Quiz]: Card generated", metadata: [
            "subcategory": subcategory,
            "correctWord": correctWord.frontText
        ])
    }
    
    /// Handles the user's answer.
    /// - Parameter answer: The answer text provided by the user.
    private func handleAnswer(_ answer: String) {
        let result = game.validateAnswer(answer)
        let responseTime = cardStartTime.map { Date().timeIntervalSince($0) } ?? 0
        
        game.updateStats(
            correct: result == .correct,
            responseTime: responseTime,
            isSpecialCard: false
        )
        
        // Generate a new card after a short delay.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            generateCard()
        }
    }
    
    // MARK: - Body
    
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
                    Text(verbatim: "Loading...")
                    Text("Cache size: \(cacheGetter.cache.count)")
                                                .font(.caption)
                                            if cacheGetter.isLoadingCache {
                                                ProgressView()
                                            }
                }
            }
            .padding()
        }
        .onAppear {
            generateCard()
        }
        // Новая подписка: если кэш обновился и содержит не менее 4 слов, пытаемся сгенерировать карточку.
        .onReceive(cacheGetter.$cache) { newCache in
            Logger.debug("[Quiz]: Cache updated", metadata: [
                            "newCacheCount": String(newCache.count),
                            "hasCurrentCard": String(currentCard != nil)
                        ])
                        if currentCard == nil && newCache.count >= 4 {
                            generateCard()
                        }
        }
    }
}
