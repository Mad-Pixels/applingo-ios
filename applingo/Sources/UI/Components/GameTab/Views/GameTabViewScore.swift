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
                style: .textMain(themeManager.currentThemeStyle, alignment: .center, lineLimit: 1)
            )
            
            DynamicTextCompact(
                model: DynamicTextModel(text: "\(score)"),
                style: .textGameBold(themeManager.currentThemeStyle, alignment: .center, lineLimit: 1)
            )
        }
    }
}
