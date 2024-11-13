import SwiftUI

final class GameSpecialManager: ObservableObject {
    static let shared = GameSpecialManager()
    private var special: [GameSpecial] = []
    
    private init() {}
    
    func register(_ item: GameSpecial) {
        special.append(item)
    }
    
    func clear() {
        special.removeAll()
    }
    
    func isSpecial(_ item: WordItemModel) -> Bool {
        special.contains { $0.isSpecial(item) }
    }
    
    func calculateBonus(baseScore: Int) -> Int {
        special.reduce(baseScore) { score, item in
            item.calculateBonus(baseScore: score)
        }
    }
    
    func getModifiers() -> [AnyViewModifier] {
        special.flatMap { $0.modifiers() }
    }
}
