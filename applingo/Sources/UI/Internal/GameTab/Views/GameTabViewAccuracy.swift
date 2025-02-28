import SwiftUI

struct GameTabViewAccuracy: View {
    let accuracy: Double
    let style: GameTabStyle
    
    var body: some View {
        Text(verbatim: "\(Int(accuracy * 100))%")
            .font(style.valueFont)
            .foregroundColor(style.textPrimaryColor)
            .monospacedDigit()
    }
}
