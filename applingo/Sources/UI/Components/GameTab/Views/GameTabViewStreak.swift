import SwiftUI

struct GameTabViewStreak: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    internal let streak: Int
    internal let style: GameTabStyle
    internal let locale: GameTabLocale
    
    var body: some View {
        VStack(spacing: 4) {
            DynamicTextCompact(
                model: DynamicTextModel(text: locale.screenStreak),
                style: .gameTab(themeManager.currentThemeStyle, color: style.textSecondaryColor)
            )

            DynamicTextCompact(
                model: DynamicTextModel(text: "\(streak)"),
                style: .gameTab(themeManager.currentThemeStyle, color: style.textPrimaryColor)
            )
        }
    }
}
