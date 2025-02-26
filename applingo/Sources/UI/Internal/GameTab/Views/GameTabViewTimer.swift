import SwiftUI

struct GameTabViewTimer: View {
    @ObservedObject var timer: GameStateUtilsTimer
    let style: GameTabStyle
    
    var body: some View {
        Text(timer.timeLeft.formatAsTimer)
            .font(style.timerFont)
            .foregroundColor(style.textPrimaryColor)
            .animation(.linear(duration: 0.1), value: timer.timeLeft)
    }
}
