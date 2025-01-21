import SwiftUI

struct GameTabViewScore: View {
    let score: Int
    let style: GameTabStyle
    
    var body: some View {
        VStack(spacing: 4) {
            Text("Score")
                .font(style.titleFont)
                .foregroundColor(style.textSecondaryColor)
            
            Text("\(score)")
                .font(style.valueFont)
                .foregroundColor(style.textPrimaryColor)
        }
    }
}
