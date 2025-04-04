import SwiftUI
import Combine

final class GameMatchViewModel: ObservableObject {
    @Published private(set) var currentCards: [MatchModelCard] = []
    @Published private(set) var rightOrder: [Int?] = []
    @Published private(set) var leftOrder: [Int?] = []
    @Published private(set) var shouldShowEmptyView = false
    @Published private(set) var isLoadingCard = false
    @Published var matchedIndices = Set<Int>()
    @Published var selectedFrontIndex: Int?
    @Published var selectedBackIndex: Int?
    @Published var highlightedOptions: [String: Color] = [:]
    
    private var cancellables = Set<AnyCancellable>()
    private var loadingTask: Task<Void, Never>?
    private var isProcessingQueue = false
    private var cardQueue: [Int] = []
    private var matchedPairsCount = 0
    private var isAddingNewCards = false
    private var shouldStopAddingCards = false

    private let game: Match
    private let maxCards = 6
    private let replaceThreshold = 2

    init(game: Match) {
        self.game = game
        resetBoard()
        generateCards()
        
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
                
                DispatchQueue.main.asyncAfter(deadline: .now() + duration) { [weak self] in
                    self?.highlightedOptions.removeValue(forKey: option)
                }
            }
            .store(in: &cancellables)
    }

    deinit {
        loadingTask?.cancel()
        shouldStopAddingCards = true
        isProcessingQueue = false
        cardQueue.removeAll()
        cancellables.removeAll()
    }
    
    func generateCards() {
        loadingTask?.cancel()
        shouldShowEmptyView = false
        isLoadingCard = true
        currentCards = []
        matchedPairsCount = 0
        shouldStopAddingCards = false

        loadingTask = Task { @MainActor in
            for attempt in 1...3 {
                if Task.isCancelled { return }
                if let items = game.getItems(maxCards) as? [DatabaseModelWord], !items.isEmpty {
                    currentCards = items.map(MatchModelCard.init)
                    fillBoard(withCount: currentCards.count)
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
        selectedFrontIndex = index
        checkMatch()
    }

    func selectBack(at index: Int) {
        selectedBackIndex = index
        checkMatch()
    }
    
    func getCardText(boardPosition: Int, isQuestion: Bool) -> String {
        let array = isQuestion ? leftOrder : rightOrder
        guard boardPosition < array.count, let cardIndex = array[boardPosition],
              cardIndex < currentCards.count else { return "" }
        return isQuestion ? currentCards[cardIndex].question : currentCards[cardIndex].answer
    }

    func isCardUpdating(boardPosition: Int, isQuestion: Bool) -> Bool {
        let array = isQuestion ? leftOrder : rightOrder
        guard boardPosition < array.count, let cardIndex = array[boardPosition] else { return false }
        return matchedIndices.contains(cardIndex)
    }
    
    private func resetBoard() {
        rightOrder = Array(repeating: nil, count: maxCards)
        leftOrder = Array(repeating: nil, count: maxCards)
        isProcessingQueue = false
        cardQueue.removeAll()
    }
    
    private func fillBoard(withCount count: Int) {
        resetBoard()
        
        let availableIndices = Array(0..<count)
        let shuffledLeft = availableIndices.shuffled()
        let countToFill = min(maxCards, shuffledLeft.count)
        
        for i in 0..<countToFill {
            leftOrder[i] = shuffledLeft[i]
        }
        
        let shuffledRight = availableIndices.shuffled()
        for i in 0..<min(maxCards, shuffledRight.count) {
            rightOrder[i] = shuffledRight[i]
        }
    }
    
    private func removeMatchedPair(questionIndex: Int, answerIndex: Int) {
        if let leftPos = leftOrder.firstIndex(of: questionIndex) {
            leftOrder[leftPos] = nil
        }
        
        if let rightPos = rightOrder.firstIndex(of: answerIndex) {
            rightOrder[rightPos] = nil
        }
    }
    
    private func addCard(cardIndex: Int) {
        cardQueue.append(cardIndex)
        if !isProcessingQueue {
            processCardQueue()
        }
    }
    
    private func processCardQueue() {
        guard !cardQueue.isEmpty else {
            isProcessingQueue = false
            return
        }
        
        let cardIndex = cardQueue.removeFirst()
        isProcessingQueue = true
        
        let freeLeftIndices = leftOrder.enumerated().filter { $0.element == nil }.map { $0.offset }
        let freeRightIndices = rightOrder.enumerated().filter { $0.element == nil }.map { $0.offset }
        guard !freeLeftIndices.isEmpty, !freeRightIndices.isEmpty else {
            isProcessingQueue = false
            return
        }
        
        let cardsOnBoard = leftOrder.compactMap { $0 }.count + rightOrder.compactMap { $0 }.count
        let totalSlots = maxCards * 2
        let occupiedRatio = Double(cardsOnBoard) / Double(totalSlots)
        
        let baseDelay = Double.random(in: 0.3...0.6)
        let delay = baseDelay * (0.7 + occupiedRatio)
        
        let shuffledLeft = freeLeftIndices.shuffled()
        let shuffledRight = freeRightIndices.shuffled()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            guard let self = self, !self.shouldStopAddingCards else { return }
            
            if !shuffledLeft.isEmpty && !shuffledRight.isEmpty {
                self.leftOrder[shuffledLeft.first!] = cardIndex
                self.rightOrder[shuffledRight.first!] = cardIndex
            }
            
            self.processCardQueue()
        }
    }
    
    private func countEmptyPairs() -> Int {
        let emptyLeft = leftOrder.filter { $0 == nil }.count
        let emptyRight = rightOrder.filter { $0 == nil }.count
        return min(emptyLeft, emptyRight)
    }
    
    private func checkMatch() {
        guard let frontPosition = selectedFrontIndex,
              let backPosition = selectedBackIndex,
              frontPosition < leftOrder.count,
              backPosition < rightOrder.count,
              let frontIndex = leftOrder[frontPosition],
              let backIndex = rightOrder[backPosition],
              frontIndex < currentCards.count,
              backIndex < currentCards.count else { return }
        
        let questionCard = currentCards[frontIndex]
        let answerCard = currentCards[backIndex]
        
        if let matchValidation = game.validation as? MatchValidation {
            matchValidation.setCurrentCard(currentCard: questionCard, currentWord: questionCard.word)
        }
        
        let result = game.validateAnswer(answerCard.answer, selected: questionCard.question)
        game.updateStats(correct: result == .correct, responseTime: 0, isSpecialCard: false)
        
        if result == .correct {
            matchedIndices.insert(frontIndex)
            matchedIndices.insert(backIndex)
            
            removeMatchedPair(questionIndex: frontIndex, answerIndex: backIndex)
            game.removeItem(questionCard.word)
            
            selectedFrontIndex = nil
            selectedBackIndex = nil
            
            matchedPairsCount += 1
            
            if matchedPairsCount >= replaceThreshold {
                addNewCardsUntilFull()
                matchedPairsCount = 0
            }
        } else {
            selectedFrontIndex = nil
            selectedBackIndex = nil
        }
    }
    
    private func addNewCardsUntilFull() {
        guard !shouldStopAddingCards else { return }
        
        let emptyPairs = countEmptyPairs()
        if emptyPairs > 0 && !isAddingNewCards {
            isAddingNewCards = true
            addNewCards()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                guard let self = self, !self.shouldStopAddingCards else { return }
                self.isAddingNewCards = false
                self.addNewCardsUntilFull()
            }
        }
    }

    private func addNewCards() {
        let emptyPairs = countEmptyPairs()
        guard emptyPairs > 0 else {
            return
        }
        
        guard let newWords = game.getItems(emptyPairs) as? [DatabaseModelWord],
              !newWords.isEmpty else {
            print("Новых слов не получено")
            return
        }
        
        let uniqueWords = filterUniqueWords(from: newWords, neededCount: emptyPairs)
        
        // Если не нашли подходящих слов, повторяем запрос
        if uniqueWords.isEmpty {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.addNewCards()
            }
            return
        }
        
        let newCards = uniqueWords.map(MatchModelCard.init)
        let startIndex = currentCards.count
        currentCards += newCards
        
        for i in startIndex..<currentCards.count {
            addCard(cardIndex: i)
        }
    }
    
    private func filterUniqueWords(from newWords: [DatabaseModelWord], neededCount: Int) -> [DatabaseModelWord] {
        var uniqueWords: [DatabaseModelWord] = []
        for word in newWords {
            let tempCard = MatchModelCard(word: word)
            if currentCards.contains(where: { $0.question == tempCard.question || $0.answer == tempCard.answer }) {
                game.removeItem(word)
            } else {
                uniqueWords.append(word)
            }
            if uniqueWords.count == neededCount {
                break
            }
        }
        return uniqueWords
    }
}
