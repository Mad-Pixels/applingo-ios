import SwiftUI

final class GameMatchBoard: ObservableObject {
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
        // Находим позиции этих индексов на доске
        if let leftPos = leftOrder.firstIndex(of: questionIndex) {
            leftOrder[leftPos] = nil
        }
        
        if let rightPos = rightOrder.firstIndex(of: answerIndex) {
            rightOrder[rightPos] = nil
        }
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
