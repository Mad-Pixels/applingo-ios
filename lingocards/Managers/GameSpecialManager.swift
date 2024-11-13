import SwiftUI

final class GameSpecialManager: ObservableObject {
    static let shared = GameSpecialManager()
    private var special: [GameSpecial] = []
    
    private init() {}
    
    func register(_ item: GameSpecial) {
        clear()
        special.append(item)
    }
    
    func clear() {
        special.removeAll()
    }
    
    func isSpecial(_ item: WordItemModel) -> Bool {
        special.contains { $0.isSpecial(item) }
    }
    
    func calculateBonus(baseScore: Int) -> Int {
        // Добавим print для отладки
        print("Number of special cards: \(special.count)")
        let finalScore = special.reduce(baseScore) { score, item in
            let bonus = item.calculateBonus(baseScore: score)
            print("Score \(score) after bonus: \(bonus)")
            return bonus
        }
        return finalScore
    }
    
    func getModifiers() -> [AnyViewModifier] {
        special.flatMap { $0.modifiers() }
    }
}
