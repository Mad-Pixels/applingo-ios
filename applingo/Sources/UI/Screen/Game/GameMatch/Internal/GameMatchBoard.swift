import SwiftUI

final class MatchBoard: ObservableObject {
    // Теперь доска хранит индексы карточек (опциональные)
    @Published private(set) var leftOrder: [Int?] = []
    @Published private(set) var rightOrder: [Int?] = []

    private let maxCards: Int

    init(maxCards: Int = 6) {
        self.maxCards = maxCards
        resetBoard()
    }

    func resetBoard() {
        leftOrder = Array(repeating: nil, count: maxCards)
        rightOrder = Array(repeating: nil, count: maxCards)
    }

    /// Заполняем доску в зависимости от количества карточек
    func fillBoard(withCount count: Int) {
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

    /// Удаляем совпавшую пару по индексам карточек
    func removeMatchedPair(questionIndex: Int, answerIndex: Int) {
        leftOrder = leftOrder.map { $0 == questionIndex ? nil : $0 }
        rightOrder = rightOrder.map { $0 == answerIndex ? nil : $0 }
    }

    /// Добавляем новую карточку, размещая её индекс в случайно выбранные свободные ячейки
    func addCard(cardIndex: Int) {
        var freeLeftIndices = leftOrder.enumerated().filter { $0.element == nil }.map { $0.offset }
        var freeRightIndices = rightOrder.enumerated().filter { $0.element == nil }.map { $0.offset }

        guard !freeLeftIndices.isEmpty, !freeRightIndices.isEmpty else { return }

        freeLeftIndices.shuffle()
        freeRightIndices.shuffle()

        leftOrder[freeLeftIndices.first!] = cardIndex
        rightOrder[freeRightIndices.first!] = cardIndex
    }

    func hasEmptySlots() -> Bool {
        leftOrder.contains(nil) || rightOrder.contains(nil)
    }
}
