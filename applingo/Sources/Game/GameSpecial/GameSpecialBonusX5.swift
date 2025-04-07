import Foundation

struct GameSpecialX5Bonus: GameSpecialBonus {
    let id = "x5_bonus"
    let title = "5x Score Bonus"
    
    func applyBonus() -> String {
        return "This card gives 5x score!"
    }
}
