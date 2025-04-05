import SwiftUI

internal class GameMatchBoard: ObservableObject {
    @Published private(set) var cards: [Int: MatchModelCard] = [:]
    @Published private(set) var columnRight: [Int?]
    @Published private(set) var columnLeft: [Int?]

    private let maxCards: Int
    private var nextID: Int = 0
    private let treashold: Int = 2
    private let addQueue = DispatchQueue(label: "GameMatchBoard.addQueue", qos: .userInitiated)

    init(maxCards: Int) {
        self.maxCards = maxCards
        self.columnLeft = Array(repeating: nil, count: maxCards)
        self.columnRight = Array(repeating: nil, count: maxCards)
    }

    /// Количество свободных парных слотов
    func freeSlotsCount() -> Int {
        let leftEmpty = columnLeft.filter { $0 == nil }.count
        let rightEmpty = columnRight.filter { $0 == nil }.count
        return min(leftEmpty, rightEmpty)
    }

    /// Количество угаданных карточек (удалённых с доски)
    private var guessedCount: Int {
        nextID - cards.count
    }

    /// Поставить карточку в очередь на добавление
    func enqueue(card: MatchModelCard) {
        guard self.freeSlotsCount() >= treashold else { return }

        let delay = guessedCount == 0 ? 0 : max(0.1, 1.0 - Double(guessedCount) * 0.1)

        addQueue.asyncAfter(deadline: .now() + delay) { [weak self] in
            DispatchQueue.main.async {
                self?.add(card: card)
            }
        }
    }

    /// Добавить карточку немедленно (внутренне вызывается очередью)
    private func add(card: MatchModelCard) {
        let freeRightPositions = getFreePositions(in: columnRight).shuffled()
        let freeLeftPositions = getFreePositions(in: columnLeft).shuffled()

        guard let right = freeRightPositions.first,
              let left = freeLeftPositions.first else {
            return
        }

        let id = nextID
        nextID += 1
        cards[id] = card
        columnRight[right] = id
        columnLeft[left] = id
    }

    /// Удалить карточку с доски
    func remove(leftPosition: Int, rightPosition: Int) {
        guard leftPosition >= 0, leftPosition < columnLeft.count,
              rightPosition >= 0, rightPosition < columnRight.count else {
            return
        }

        guard let leftCardID = columnLeft[leftPosition],
              let rightCardID = columnRight[rightPosition],
              leftCardID == rightCardID else {
            return
        }

        cards.removeValue(forKey: leftCardID)
        columnLeft[leftPosition] = nil
        columnRight[rightPosition] = nil
    }

    /// Получить карточку по позиции (вопрос/ответ)
    func get(position: Int, isQuestion: Bool) -> MatchModelCard? {
        let column = isQuestion ? columnLeft : columnRight
        guard position >= 0, position < column.count,
              let cardID = column[position] else {
            return nil
        }
        return cards[cardID]
    }

    /// Получить текст карточки по позиции (вопрос/ответ)
    func text(position: Int, isLeft: Bool) -> String {
        let column = isLeft ? columnLeft : columnRight
        guard position >= 0, position < column.count,
              let cardID = column[position],
              let card = cards[cardID] else {
            return ""
        }
        return isLeft ? card.question : card.answer
    }

    /// Список свободных индексов в колонке
    private func getFreePositions(in column: [Int?]) -> [Int] {
        column.enumerated()
            .filter { $0.element == nil }
            .map { $0.offset }
    }
}
