import SwiftUI

struct GameTabViewTimer: View {
    let timeLeft: TimeInterval
    let style: GameTabStyle
    
    var body: some View {
        Text(timeLeft.formatAsTimer)
            .font(style.timerFont)
            .foregroundColor(style.textPrimaryColor)
    }
}
