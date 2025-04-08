import SwiftUI

struct GameSpecialBonusBronze: GameSpecialBonus {
    let id: String = "bronze"
    let name: String = "bronze"
    let scoreBonus: Int = 50
    let penaltyBonus: Int = 10

    let backgroundColor: DynamicPatternModel = DynamicPatternModel(
        colors: [
            Color(hex: "8C4F1A"),
            Color(hex: "7A4116"),
            Color(hex: "693612"),
            Color(hex: "572B0F"),
            Color(hex: "46200B")
        ]
    )
    
    let borderColor: DynamicPatternModel = DynamicPatternModel(
        colors: [
            Color(hex: "8C4F1A"),
            Color(hex: "7A4116"),
            Color(hex: "693612"),
            Color(hex: "572B0F"),
            Color(hex: "46200B")
        ]
    )
    
    let icon: Image? = Image(systemName: "star")
}
