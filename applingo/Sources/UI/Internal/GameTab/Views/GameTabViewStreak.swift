import SwiftUI

struct GameTabViewStreak: View {
    let streak: Int
    let style: GameTabStyle
    let locale: GameTabLocale
    
    var body: some View {
        VStack(spacing: 4) {
            Text(locale.screenStreak)
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
