import SwiftUI

struct GameTabViewScore: View {
    let score: Int
    let style: GameTabStyle
    let locale: GameTabLocale
    
    var body: some View {
        VStack(spacing: 4) {
            Text(locale.screenScore)
                .font(style.titleFont)
                .foregroundColor(style.textSecondaryColor)
            
            Text(verbatim: "\(score)")
                .font(style.valueFont)
                .foregroundColor(style.textPrimaryColor)
                .onAppear {
                    Logger.debug("[GameTabViewScore]: Score displayed: \(score)")
                }
                .onChange(of: score) { newScore in
                    Logger.debug("[GameTabViewScore]: Score updated: \(newScore)")
                }
        }
    }
}
