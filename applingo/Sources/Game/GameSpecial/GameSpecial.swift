import Foundation

final class GameSpecial {
    static let shared = GameSpecial()
    
    private let availableBonuses: [GameSpecialBonus] = [
        GameSpecialX5Bonus()
    ]
    
    private init() {}

    func getRandomBonus() -> GameSpecialBonus {
        return availableBonuses.first!
    }
}
