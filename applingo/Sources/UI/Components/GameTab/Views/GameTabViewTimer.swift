import SwiftUI

internal struct GameTabViewTimer: View {
    @EnvironmentObject private var themeManager: ThemeManager

    @ObservedObject var timer: GameStateUtilsTimer

    internal let style: GameTabStyle

    var body: some View {
        DynamicTextCompact(
            model: DynamicTextModel(text: timer.timeLeft.formatAsTimer),
            style: .textGameBold(themeManager.currentThemeStyle, alignment: .center, lineLimit: 1)
        )
        .animation(.linear(duration: 0.1), value: timer.timeLeft)
    }
}
