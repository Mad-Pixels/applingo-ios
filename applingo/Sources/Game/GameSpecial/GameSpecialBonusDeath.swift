import SwiftUI

struct GameSpecialBonusDeath: GameSpecialBonus {
    let id: String = "death"
    let name: String = "death"
    let scoreBonus: Int = 1
    let penaltyBonus: Int = 10000

    let backgroundColor: DynamicPatternModel = DynamicPatternModel(
        colors: [
            Color(hex: "8B0000"),
            Color(hex: "B22222"),
            Color(hex: "A40000"),
            Color(hex: "990000"),
            Color(hex: "660000")
        ]
    )
    
    let borderColor: DynamicPatternModel = DynamicPatternModel(
        colors: [
            Color(hex: "8B0000"),
            Color(hex: "B22222"),
            Color(hex: "A40000"),
            Color(hex: "990000"),
            Color(hex: "660000")
        ]
    )

    let icon: Image? = Image(systemName: "exclamationmark.triangle.fill")
}
