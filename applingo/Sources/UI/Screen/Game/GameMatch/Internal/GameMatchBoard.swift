import SwiftUI

internal class GameMatchBoard: ObservableObject {
    @Published private(set) var cards: [Int: MatchModelCard] = [:]
    @Published private(set) var columnRight: [Int?]
    @Published private(set) var columnLeft: [Int?]
    
    private let maxCards: Int
    private var nextID: Int = 0
    private let treashold: Int = 2

    init(maxCards: Int) {
        self.columnLeft = Array(repeating: nil, count: maxCards)
        self.columnRight = Array(repeating: nil, count: maxCards)
        self.maxCards = maxCards
    }
    
    func freeSlotsCount() -> Int {
        let leftEmpty = columnLeft.filter { $0 == nil }.count
        let rightEmpty = columnRight.filter { $0 == nil }.count
        return min(leftEmpty, rightEmpty)
    }
    
    func add(card: MatchModelCard) {
        let freeRightPositions = getFreePositions(in: columnRight)
        let freeLeftPositions = getFreePositions(in: columnLeft)
        
        guard !freeLeftPositions.isEmpty, !freeRightPositions.isEmpty else {
            return
        }
        
        let id = nextID
        nextID += 1
        cards[id] = card
        
        let randomRightPosition = freeRightPositions.randomElement()!
        let randomLeftPosition = freeLeftPositions.randomElement()!
        columnRight[randomRightPosition] = id
        columnLeft[randomLeftPosition] = id
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
    
    func text(position: Int, isLeft: Bool) -> String {
        let column = isLeft ? columnLeft : columnRight
        guard position >= 0, position < column.count,
              let cardID = column[position],
              let card = cards[cardID] else {
            return ""
        }
        return isLeft ? card.question : card.answer
    }
    
    private func getFreePositions(in column: [Int?]) -> [Int] {
        return column.enumerated()
            .filter { $0.element == nil }
            .map { $0.offset }
    }
}
