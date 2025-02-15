import SwiftUI

/// A view that presents a quiz game interface.
/// It generates quiz cards based on a word cache and handles user answers.
struct GameQuiz: View {
    @Environment(\.dismiss) private var dismiss
    // MARK: - Properties
    
    @ObservedObject var game: Quiz
    @StateObject private var style: GameQuizStyle
    @StateObject private var locale = GameQuizLocale()
    // Изменён тип с BaseGameCache<...> на конкретный QuizCache
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
            Logger.debug("[GameQuiz]: Attempting to generate card", metadata: [
                "isLoading": String(game.isLoadingCache)
            ])
            
            // Получаем слова из игры
            guard let items = game.getItems(4) as? [DatabaseModelWord] else {
                Logger.debug("[GameQuiz]: Failed to get items, waiting for cache")
                return
            }
            
            let correctWord = items[0]
            game.removeItem(correctWord)
            
            currentCard = QuizModelCard(
                word: correctWord,
                allWords: items,
                showingFront: Bool.random()
            )
            
            if let validation = game.validation as? QuizValidation,
               let card = currentCard {
                validation.setCurrentCard(currentCard: card, currentWord: correctWord)
            }
            
            cardStartTime = Date()
            
            Logger.debug("[GameQuiz]: Card generated successfully")
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
                    if game.isLoadingCache {
                                            ProgressView()
                                        }
                }
            }
            .padding()
        }
        .onAppear {
            generateCard()
        }
        // Если кэш обновился и содержит не менее 4 слов, пытаемся сгенерировать карточку.
        .onReceive(game.$isLoadingCache) { isLoading in
                    Logger.debug("[GameQuiz]: Cache loading state changed", metadata: [
                        "isLoading": String(isLoading)
                    ])
                    
                    if !isLoading && currentCard == nil {
                        generateCard()
                    }
                }
                .onReceive(game.state.$isGameOver) { isGameOver in
                    if isGameOver {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            dismiss()
                        }
                    }
                }
///
    }
}
