import SwiftUI

struct GameSpecialBonusUltra: GameSpecialBonus {
    let id: String = "ultra"
    let name: String = "ultra"
    let scoreBonus: Int = 500
    let penaltyBonus: Int = 50

    let backgroundColor: DynamicPatternModel = DynamicPatternModel(
        colors: [
            Color(hex: "A020F0"),
            Color(hex: "8B00FF"),
            Color(hex: "7A0BC0"),
            Color(hex: "6600CC"),
            Color(hex: "4B0082")
        ]
    )

    let borderColor: DynamicPatternModel = DynamicPatternModel(
        colors: [
            Color(hex: "A020F0"),
            Color(hex: "8B00FF"),
            Color(hex: "7A0BC0"),
            Color(hex: "6600CC"),
            Color(hex: "4B0082")
        ]
    )

    let icon: Image? = Image(systemName: "sparkles")
}
