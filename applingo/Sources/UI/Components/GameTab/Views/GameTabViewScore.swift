import SwiftUI

internal struct GameTabViewScore: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    internal let score: Int
    internal let style: GameTabStyle
    internal let locale: GameTabLocale
    
    var body: some View {
        VStack(spacing: 4) {
            DynamicTextCompact(
                model: DynamicTextModel(text: locale.screenScore),
                style: .gameTab(themeManager.currentThemeStyle, color: style.textSecondaryColor)
            )

            DynamicTextCompact(
                model: DynamicTextModel(text: "\(score)"),
                style: .gameTab(themeManager.currentThemeStyle, color: style.textPrimaryColor)
            )
        }
    }
}
