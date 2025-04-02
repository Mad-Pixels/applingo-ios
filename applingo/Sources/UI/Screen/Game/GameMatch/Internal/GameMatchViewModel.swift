import Combine
import SwiftUI

internal final class MatchGameViewModel: ObservableObject {
    @Published private(set) var currentCards: [MatchModelCard] = []
    @Published private(set) var shouldShowEmptyView = false
    @Published private(set) var isLoadingCard = false
    
    @Published var selectedFrontIndex: Int?
    @Published var selectedBackIndex: Int?
    @Published var matchedIndices: Set<Int> = []
    
    private var loadingTask: Task<Void, Never>?
    private var cancellables = Set<AnyCancellable>()
    private var cardStartTime: Date?
    private let game: Match
    
    let replaceThreshold = 3
    let maxCards = 4
    
    init(game: Match) {
        self.game = game
    }
    
    deinit {
        loadingTask?.cancel()
        cancellables.removeAll()
    }
    
    func generateCards() {
        loadingTask?.cancel()
        
        shouldShowEmptyView = false
        isLoadingCard = true
        currentCards = []
        
        loadingTask = Task { @MainActor in
            for attempt in 1...3 {
                if Task.isCancelled {
                    return
                }
                
                if let items = game.getItems(maxCards) as? [DatabaseModelWord], !items.isEmpty {
                    let validWords = items.prefix(maxCards).filter { $0.id != nil }
                    
                    if validWords.count < maxCards {
                        Logger.debug("[MatchViewModel]: WARNING - Not enough valid words", metadata: [
                            "validWordsCount": String(validWords.count),
                            "requiredCount": String(maxCards)
                        ])
                    }
                    
                    validWords.forEach { game.removeItem($0) }
                    
                    let cards = validWords.map { MatchModelCard(word: $0) }
                    
                    currentCards = cards
                    cardStartTime = Date()
                    
                    resetGameState()
                    isLoadingCard = false
                    return
                }
                
                if attempt < 3 {
                    try? await Task.sleep(nanoseconds: 800_000_000)
                }
            }
            
            shouldShowEmptyView = true
            isLoadingCard = false
        }
    }
    
    func selectFront(at index: Int) {
        guard index >= 0, index < currentCards.count else { return }
        
        selectedFrontIndex = (selectedFrontIndex == index) ? nil : index
        
        if cardStartTime == nil && (selectedFrontIndex != nil || selectedBackIndex != nil) {
            cardStartTime = Date()
        } else if selectedFrontIndex == nil && selectedBackIndex == nil {
            cardStartTime = nil
        }
        
        checkMatch()
    }
    
    func selectBack(at index: Int) {
        guard index >= 0, index < currentCards.count else { return }
        
        selectedBackIndex = (selectedBackIndex == index) ? nil : index
        
        if cardStartTime == nil && (selectedFrontIndex != nil || selectedBackIndex != nil) {
            cardStartTime = Date()
        } else if selectedFrontIndex == nil && selectedBackIndex == nil {
            cardStartTime = nil
        }
        
        checkMatch()
    }
    
    private func checkMatch() {
        guard let frontIndex = selectedFrontIndex,
              let backIndex = selectedBackIndex,
              frontIndex >= 0, frontIndex < currentCards.count,
              backIndex >= 0, backIndex < currentCards.count else {
            return
        }
        
        let responseTime = cardStartTime.map { Date().timeIntervalSince($0) } ?? 0
        
        let frontId = currentCards[frontIndex].word.id
        let backId = currentCards[backIndex].word.id
        let isCorrect = frontId == backId
        
        if let matchValidation = game.validation as? MatchValidation {
            let card = currentCards[frontIndex]
            matchValidation.setCurrentCard(currentCard: card, currentWord: card.word)
            
            let result: GameValidationResult = isCorrect ? .correct : .incorrect
            game.validation.playFeedback(result, answer: currentCards[backIndex].answer)
        }
        
        if isCorrect {
            matchedIndices.insert(frontIndex)
            matchedIndices.insert(backIndex)
            
            if matchedIndices.count >= replaceThreshold {
                generateCards()
            }
        }
        
        game.updateStats(
            correct: isCorrect,
            responseTime: responseTime,
            isSpecialCard: false
        )
        
        selectedFrontIndex = nil
        selectedBackIndex = nil
        cardStartTime = nil
        
        Logger.debug("[MatchViewModel]: Pair checked", metadata: [
            "isMatch": String(isCorrect),
            "responseTime": String(responseTime),
            "matchedIndicesCount": String(matchedIndices.count)
        ])
    }
    
    private func resetGameState() {
        matchedIndices.removeAll()
        selectedFrontIndex = nil
        selectedBackIndex = nil
        cardStartTime = nil
    }
}
