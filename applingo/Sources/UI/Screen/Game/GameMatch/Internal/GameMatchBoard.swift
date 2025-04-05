import SwiftUI

internal class GameMatchBoard: ObservableObject {
    @Published private(set) var cards: [Int: MatchModelCard] = [:]
    @Published private(set) var columnRight: [Int?]
    @Published private(set) var columnLeft: [Int?]

    private let maxCards: Int
    private var nextID: Int = 0
    private let treashold: Int = 2
    private let addQueue = DispatchQueue(label: "com.applingo.gameMatchBoard", qos: .userInitiated)

    private var pendingDelay: TimeInterval = 0

    init(maxCards: Int) {
        self.maxCards = maxCards
        self.columnLeft = Array(repeating: nil, count: maxCards)
        self.columnRight = Array(repeating: nil, count: maxCards)
    }

    func freeSlotsCount() -> Int {
        let leftEmpty = columnLeft.filter { $0 == nil }.count
        let rightEmpty = columnRight.filter { $0 == nil }.count
        return min(leftEmpty, rightEmpty)
    }

    func enqueue(card: MatchModelCard) {
        guard self.freeSlotsCount() >= treashold else { return }

        let visibleCount = cards.count
        let baseDelay: TimeInterval

        switch visibleCount {
        case 0:
            baseDelay = 0
        case 1...2:
            baseDelay = 1.6
        case 3...4:
            baseDelay = 1.2
        case 5:
            baseDelay = 0.8
        default:
            baseDelay = 0.2
        }

        let scheduledDelay = pendingDelay
        pendingDelay += baseDelay

        addQueue.asyncAfter(deadline: .now() + scheduledDelay) { [weak self] in
            DispatchQueue.main.async {
                guard let self else { return }
                self.add(card: card)
                self.pendingDelay = max(0, self.pendingDelay - baseDelay)
            }
        }
    }

    func text(position: Int, isLeft: Bool) -> String {
        let column = isLeft ? columnLeft : columnRight
        guard position >= 0, position < column.count,
              let cardID = column[position],
              let card = cards[cardID] else {
            return ""
        }
        return isLeft ? card.question : card.answer
    }

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

    func get(position: Int, isQuestion: Bool) -> MatchModelCard? {
        let column = isQuestion ? columnLeft : columnRight
        guard position >= 0, position < column.count,
              let cardID = column[position] else {
            return nil
        }
        return cards[cardID]
    }

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

    private func getFreePositions(in column: [Int?]) -> [Int] {
        column.enumerated()
            .filter { $0.element == nil }
            .map { $0.offset }
    }

    private var guessedCount: Int {
        nextID - cards.count
    }
}
