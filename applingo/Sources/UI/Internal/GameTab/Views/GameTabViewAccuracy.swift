import SwiftUI

struct GameTabViewAccuracy: View {
    let accuracy: Double
    let style: GameTabStyle
    
    var body: some View {
        VStack(spacing: 4) {
            Text("Accuracy")
                .font(style.titleFont)
                .foregroundColor(style.textSecondaryColor)
            
            Text("\(Int(accuracy * 100))%")
                .font(style.valueFont)
                .foregroundColor(style.textPrimaryColor)
        }
    }
}
