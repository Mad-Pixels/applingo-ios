import Foundation

/// A view model for the Quiz game that encapsulates the logic for generating quiz cards and handling user answers.
///
/// The `QuizViewModel` is responsible for:
/// - Generating new quiz cards by retrieving a set of words from the game's cache.
/// - Setting up the current quiz card and delegating answer validation to the game model.
/// - Handling user answers by measuring response time, validating the answer, and updating game statistics.
/// - Regenerating quiz cards after an answer is processed.
///
/// This class is an `ObservableObject` so that SwiftUI views can reactively update when the current card changes.
final class QuizViewModel: ObservableObject {
    @Published private(set) var currentCard: QuizModelCard?
    @Published private(set) var shouldShowEmptyView = false
    
    private var cardStartTime: Date?
    private let game: Quiz
    private var loadingTask: Task<Void, Never>?
    
    init(game: Quiz) {
        self.game = game
    }
    
    func generateCard() {
        // Отменяем предыдущую загрузку если она есть
        loadingTask?.cancel()
        currentCard = nil
        shouldShowEmptyView = false
        
        loadingTask = Task { @MainActor in
            // Три попытки с паузой в 1 секунду
            for attempt in 1...2 {
                if Task.isCancelled { return }
                
                if let items = game.getItems(4) as? [DatabaseModelWord] {
                    let correctWord = items[0]
                    game.removeItem(correctWord)
                    
                    var shuffledWords = items
                    shuffledWords.shuffle()
                    
                    currentCard = QuizModelCard(
                        word: correctWord,
                        allWords: shuffledWords,
                        showingFront: Bool.random()
                    )
                    
                    if let validation = game.validation as? QuizValidation,
                       let card = currentCard {
                        validation.setCurrentCard(currentCard: card, currentWord: correctWord)
                    }
                    
                    cardStartTime = Date()
                    return
                }
                
                if attempt < 3 {
                    try? await Task.sleep(nanoseconds: 500_000_000) // 1/2 секунды
                }
            }
            
            shouldShowEmptyView = true
        }
    }
    
    func handleAnswer(_ answer: String) {
        let responseTime = cardStartTime.map { Date().timeIntervalSince($0) } ?? 0
        let result = game.validateAnswer(answer)
        
        game.updateStats(
            correct: result == .correct,
            responseTime: responseTime,
            isSpecialCard: false
        )
        
        generateCard()
    }
    
    deinit {
        loadingTask?.cancel()
    }
}
