import SwiftUI

internal struct GameTabViewAccuracy: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    internal let accuracy: Double
    internal let style: GameTabStyle

    var body: some View {
        DynamicTextCompact(
            model: DynamicTextModel(text: "\(Int(accuracy * 100))%"),
            style: .textGameBold(themeManager.currentThemeStyle, alignment: .center, lineLimit: 1)
        )
        .monospacedDigit()
    }
}
