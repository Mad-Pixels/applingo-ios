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
                Image(systemName: "flame.fill")
                    .font(.system(size: style.iconSize))
                    .foregroundColor(style.accentColor)
                
                Text("\(streak)")
                    .font(style.valueFont)
                    .foregroundColor(style.textPrimaryColor)
            }
        }
    }
}
