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
        guard cache.count >= 4 else { return }
        
        // Get 4 unique words.
        var selectedWords: Set<DatabaseModelWord> = []
        var attempts = 0
        let maxAttempts = 20
        
        while selectedWords.count < 4 && attempts < maxAttempts {
            if let word = cache.randomElement() {
                // Check for duplicate front/back texts.
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
        let correctWord = wordsArray[0] // Можно рандомно выбирать корректный ответ.
        let showingFront = Bool.random()
        
        cacheGetter.removeFromCache(correctWord)
        
        currentCard = QuizModelCard(
            correctWord: correctWord,
            allWords: wordsArray,
            showingFront: showingFront
        )
        
        // Set the current card in the game validation if applicable.
        if let validation = game.validation as? QuizValidation, let card = currentCard {
            validation.setCurrentCard(card)
        }
        
        cardStartTime = Date()
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
                }
            }
            .padding()
        }
        .onAppear {
            generateCard()
        }
    }
}
