import SwiftUI
import Combine

final class GameMatchViewModel: ObservableObject {
    @Published private(set) var currentCards: [MatchModelCard] = []
    @Published private(set) var isLoadingCard = false
    @Published private(set) var shouldShowEmptyView = false

    @Published var matchedIndices = Set<Int>()
    @Published var selectedFrontIndex: Int?
    @Published var selectedBackIndex: Int?

    let board: GameMatchBoard

    private let game: Match
    private let maxCards = 6
    private let replaceThreshold = 2

    private var loadingTask: Task<Void, Never>?
    private var cancellables = Set<AnyCancellable>()

    init(game: Match) {
        self.game = game
        self.board = GameMatchBoard(maxCards: maxCards)
        generateCards()
    }

    deinit {
        loadingTask?.cancel()
    }

    func generateCards() {
        loadingTask?.cancel()
        shouldShowEmptyView = false
        isLoadingCard = true
        currentCards = []

        loadingTask = Task { @MainActor in
            for attempt in 1...3 {
                if Task.isCancelled { return }

                if let items = game.getItems(maxCards) as? [DatabaseModelWord], !items.isEmpty {
                    currentCards = items.map(MatchModelCard.init)
                    // Заполняем доску карточками
                    board.fillBoard(withCount: currentCards.count)
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

    private func checkMatch() {
        guard let frontPosition = selectedFrontIndex,
              let backPosition = selectedBackIndex,
              frontPosition < board.leftOrder.count,
              backPosition < board.rightOrder.count,
              let frontIndex = board.leftOrder[frontPosition],
              let backIndex = board.rightOrder[backPosition],
              frontIndex < currentCards.count,
              backIndex < currentCards.count else { return }

        let questionCard = currentCards[frontIndex]
        let answerCard = currentCards[backIndex]

        if let matchValidation = game.validation as? MatchValidation {
            matchValidation.setCurrentCard(currentCard: questionCard, currentWord: questionCard.word)
        }

        let result = game.validateAnswer(answerCard.answer)

        game.updateStats(correct: result == .correct, responseTime: 0, isSpecialCard: false)

        if result == .correct {
            matchedIndices.insert(frontIndex)
            matchedIndices.insert(backIndex)

            // Удаляем совпавшую пару
            board.removeMatchedPair(questionIndex: frontIndex, answerIndex: backIndex)

            if matchedIndices.count / 2 >= replaceThreshold {
                replaceMatchedCards()
            }
        }

        selectedFrontIndex = nil
        selectedBackIndex = nil
    }

    private func replaceMatchedCards() {
        let numberOfPairsToReplace = matchedIndices.count / 2
        matchedIndices.removeAll()

        Task { @MainActor in
            guard let newWords = game.getItems(numberOfPairsToReplace) as? [DatabaseModelWord],
                  !newWords.isEmpty else { return }

            let newCards = newWords.map(MatchModelCard.init)
            let startIndex = currentCards.count
            currentCards += newCards

            for i in startIndex..<currentCards.count {
                let delay = Double.random(in: 0.2...0.6)
                try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
                // Добавляем новую карточку на доску
                board.addCard(cardIndex: i)
            }
        }
    }

    func getCardText(boardPosition: Int, isQuestion: Bool) -> String {
        let array = isQuestion ? board.leftOrder : board.rightOrder
        guard boardPosition < array.count, let cardIndex = array[boardPosition],
              cardIndex < currentCards.count else { return "" }
        
        return isQuestion ? currentCards[cardIndex].question : currentCards[cardIndex].answer
    }

    func isCardUpdating(boardPosition: Int, isQuestion: Bool) -> Bool {
        let array = isQuestion ? board.leftOrder : board.rightOrder
        guard boardPosition < array.count, let cardIndex = array[boardPosition] else { return false }
        return matchedIndices.contains(cardIndex)
    }
}
