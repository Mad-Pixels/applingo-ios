import SwiftUI

internal struct GameTabViewTimer: View {
    @EnvironmentObject private var themeManager: ThemeManager

    @ObservedObject var timer: GameStateUtilsTimer

    internal let style: GameTabStyle

    var body: some View {
        DynamicTextCompact(
            model: DynamicTextModel(text: timer.timeLeft.formatAsTimer),
            style: .gameTab(themeManager.currentThemeStyle, color: style.textPrimaryColor)
        )
        .animation(.linear(duration: 0.1), value: timer.timeLeft)
    }
}
