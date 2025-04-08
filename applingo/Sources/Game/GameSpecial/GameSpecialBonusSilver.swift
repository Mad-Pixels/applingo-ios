import SwiftUI

struct GameSpecialBonusSilver: GameSpecialBonus {
    let id: String = "silver"
    let name: String = "silver"
    let scoreBonus: Int = 100
    let penaltyBonus: Int = 20

    let backgroundColor: DynamicPatternModel = DynamicPatternModel(
        colors: [
            Color(hex: "C0C0C0"),
            Color(hex: "B0B0B0"),
            Color(hex: "A0A0A0"),
            Color(hex: "909090"),
            Color(hex: "808080")
        ]
    )
    
    let borderColor: DynamicPatternModel = DynamicPatternModel(
        colors: [
            Color(hex: "C0C0C0"),
            Color(hex: "B0B0B0"),
            Color(hex: "A0A0A0"),
            Color(hex: "909090"),
            Color(hex: "808080")
        ]
    )
    
    let icon: Image? = Image(systemName: "star.leadinghalf.filled")
}
