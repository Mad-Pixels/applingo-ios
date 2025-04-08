import Foundation

final class SwipeSpecial {
    static let shared = SwipeSpecial()

    private let bonusesWithWeights: [(bonus: GameSpecialBonus, weight: Int)] = [
        (GameSpecialBonusBronze(), 45),
        (GameSpecialBonusSilver(), 25),
        (GameSpecialBonusGold(), 15),
        (GameSpecialBonusUltra(), 10),
        (GameSpecialBonusDeath(), 5)
    ]

    private init() {}

    func maybeGetRandomBonus(chance: Double = 0.2) -> GameSpecialBonus? {
        guard Double.random(in: 0...1) < chance else { return nil }

        let totalWeight = bonusesWithWeights.map(\.weight).reduce(0, +)
        let random = Int.random(in: 1...totalWeight)

        var current = 0
        for (bonus, weight) in bonusesWithWeights {
            current += weight
            if random <= current {
                return bonus
            }
        }

        return nil
    }
}
