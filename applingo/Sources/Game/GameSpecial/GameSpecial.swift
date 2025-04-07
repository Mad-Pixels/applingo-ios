import Foundation

final class GameSpecial {
    static let shared = GameSpecial()
    
    private let availableBonuses: [GameSpecialBonus] = [
        GameSpecialX5Bonus()
    ]
    
    private init() {}

    func maybeGetRandomBonus(chance: Double = 0.3) -> GameSpecialBonus? {
        guard Double.random(in: 0...1) < chance else { return nil }
        return availableBonuses.randomElement()
    }
}
