import SwiftUI

struct GameSpecialX5Bonus: GameSpecialBonus {
    let id: String = "x5_bonus"
    let name: String = "X5 Bonus"
    let scoreBonus: Int = 5
    let penaltyBonus: Int = 50

    let backgroundColor: Color = Color.yellow.opacity(0.3)
    let borderColor: Color = Color.orange
    let icon: Image? = Image(systemName: "star.fill")
}
