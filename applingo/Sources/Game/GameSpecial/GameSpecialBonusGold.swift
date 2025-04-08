import SwiftUI

struct GameSpecialBonusGold: GameSpecialBonus {
    let id: String = "gold"
    let name: String = "gold"
    let scoreBonus: Int = 200
    let penaltyBonus: Int = 30

    let backgroundColor: DynamicPatternModel = DynamicPatternModel(
        colors: [
            Color(hex: "D4A200"),
            Color(hex: "BF8F00"),
            Color(hex: "AA7C00"),
            Color(hex: "956900"),
            Color(hex: "805600")
        ]
    )

    let borderColor: DynamicPatternModel = DynamicPatternModel(
        colors: [
            Color(hex: "D4A200"),
            Color(hex: "BF8F00"),
            Color(hex: "AA7C00"),
            Color(hex: "956900"),
            Color(hex: "805600")
        ]
    )

    let icon: Image? = Image(systemName: "star.fill")
}
