import SwiftUI
import Combine

final class GameMatchViewModel: ObservableObject {
    @Published private(set) var currentCards: [MatchModelCard] = []
    @Published private(set) var isLoadingCard = false
    @Published private(set) var shouldShowEmptyView = false

    @Published var matchedIndices = Set<Int>()
    @Published var selectedFrontIndex: Int?
    @Published var selectedBackIndex: Int?

    let board: MatchBoard

    private let game: Match
    private let maxCards = 6
    private let replaceThreshold = 2

    private var loadingTask: Task<Void, Never>?
    private var cancellables = Set<AnyCancellable>()

    init(game: Match) {
        self.game = game
        self.board = MatchBoard(maxCards: maxCards)
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
                    // Передаём количество карточек
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
        guard let frontIndex = selectedFrontIndex,
              let backIndex = selectedBackIndex,
              currentCards.indices.contains(frontIndex),
              currentCards.indices.contains(backIndex) else { return }

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

            // Теперь передаём индексы
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
                // Передаём индекс новой карточки
                board.addCard(cardIndex: i)
            }
        }
    }

    func getCardText(index: Int, isQuestion: Bool) -> String {
        guard currentCards.indices.contains(index) else { return "" }
        return isQuestion ? currentCards[index].question : currentCards[index].answer
    }

    func isCardUpdating(index: Int) -> Bool {
        matchedIndices.contains(index)
    }
}
