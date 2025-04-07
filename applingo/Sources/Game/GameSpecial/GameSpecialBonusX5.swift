import Foundation

struct GameSpecialX5Bonus: GameSpecialBonus {
    let id: String = "x5_bonus"
    let name: String = "X5 Bonus"
    let scoreBonus: Int = 5
    let penaltyBonus: Int = 50
}
