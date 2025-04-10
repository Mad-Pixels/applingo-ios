import SwiftUI
import Combine

final class MatchViewModel: ObservableObject {
    @Published private(set) var shouldShowEmptyView = false
    @Published private(set) var isLoadingCards = false
    @Published var highlightedOptions: [String: Color] = [:]
    @Published var gameBoard: GameMatchBoard
    
    private var selectionStartTime: Date?
    private var loadingTask: Task<Void, Never>?
    private var cancellables = Set<AnyCancellable>()
    private let maxCards = 6
    private let game: Match
    
    init(game: Match) {
        self.gameBoard = GameMatchBoard(maxCards: maxCards)
        self.game = game
        
        NotificationCenter.default.publisher(for: .visualFeedbackShouldUpdate)
            .receive(on: RunLoop.main)
            .sink { [weak self] notification in
                guard let self = self,
                      let userInfo = notification.userInfo,
                      let option = userInfo["option"] as? String,
                      let color = userInfo["color"] as? Color,
                      let duration = userInfo["duration"] as? TimeInterval else {
                    return
                }
                self.highlightedOptions[option] = color
                
                DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                    self.highlightedOptions.removeValue(forKey: option)
                }
            }
            .store(in: &cancellables)
    }
    
    deinit {
        loadingTask?.cancel()
    }
    
    func generateCards() {
        let slots = gameBoard.freeSlotsCount()
        if slots <= 0 { return }
        
        shouldShowEmptyView = false
        isLoadingCards = true
        loadingTask?.cancel()
        
        let activeWordIDs = Set(gameBoard.cards.values.compactMap { $0.word.id })
        (game.cache).usedWordIDs = activeWordIDs

        loadingTask = Task { @MainActor in
            for attempt in 1...3 {
                if Task.isCancelled { return }
                
                if let items = game.getItems(slots) as? [DatabaseModelWord], !items.isEmpty {
                    for item in items {
                        gameBoard.enqueue(card: MatchModelCard(word: item))
                    }
                    isLoadingCards = false
                    return
                }
                
                if attempt < 3 {
                    try? await Task.sleep(nanoseconds: 800_000_000)
                }
            }
            
            shouldShowEmptyView = true
            self.isLoadingCards = false
        }
    }
    
    func checkMatch(selectedLeft: Int, selectedRight: Int) {
        guard let questionCard = gameBoard.get(position: selectedLeft, isQuestion: true),
              let answerCard = gameBoard.get(position: selectedRight, isQuestion: false)
        else {
            return
        }
        
        let responseTime: TimeInterval
        if let start = selectionStartTime {
            responseTime = Date().timeIntervalSince(start)
        } else {
            responseTime = 0
        }
        selectionStartTime = nil
        
        if let validation = game.validation as? MatchValidation {
            validation.setCurrentCard(currentCard: questionCard, currentWord: answerCard.word)
        }
        let result = game.validateAnswer(answerCard.answer)
        
        game.validation.playFeedback(
            result,
            answer: answerCard.answer,
            selected: questionCard.question
        )
        game.updateStats(
            correct: result == .correct,
            responseTime: responseTime,
            specialBonus: nil
        )
        
        if result == .correct {
            gameBoard.remove(leftPosition: selectedLeft, rightPosition: selectedRight)
            game.removeItem(questionCard.word)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + MATCH_CORRECT_FEEDBACK_DURATION) {
                self.isLoadingCards = true
                self.generateCards()
            }
        }
    }
    
    func startTimer() {
        selectionStartTime = Date()
    }
}
