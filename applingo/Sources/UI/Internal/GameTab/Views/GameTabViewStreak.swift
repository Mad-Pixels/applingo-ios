import SwiftUI

struct GameTabViewStreak: View {
    let streak: Int
    let style: GameTabStyle
    
    var body: some View {
        VStack(spacing: 4) {
            Text("Streak")
                .font(style.titleFont)
                .foregroundColor(style.textSecondaryColor)
            
            HStack(spacing: 4) {
                Text("\(streak)")
                    .font(style.valueFont)
                    .foregroundColor(style.textPrimaryColor)
            }
        }
    }
}
