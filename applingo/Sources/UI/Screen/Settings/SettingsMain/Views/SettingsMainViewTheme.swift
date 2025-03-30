import SwiftUI

internal struct SettingsMainViewTheme: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    @ObservedObject private var locale: SettingsMainLocale
    
    private let style: SettingsMainStyle
    
    /// Initializes the SettingsMainViewTheme.
    /// - Parameters:
    ///   - style: `SettingsMainStyle` object that defines the visual style.
    ///   - locale: `SettingsMainLocale` object that provides localized strings.
    init(
        style: SettingsMainStyle,
        locale: SettingsMainLocale
    ) {
        self.locale = locale
        self.style = style
    }
    
    var body: some View {
        VStack(spacing: style.spacing) {
            SectionHeader(
                title: locale.screenSubtitleTheme,
                style: .block(ThemeManager.shared.currentThemeStyle)
            )
            .padding(.top, 8)
            
            VStack(spacing: style.spacing) {
                ItemPicker(
                    selectedValue: $themeManager.currentTheme,
                    items: themeManager.supportedThemes,
                    onChange: { newTheme in themeManager.setTheme(to: newTheme) },
                    content: { theme in
                        DynamicText(
                            model: DynamicTextModel(text: getLocalizedThemeName(for: theme)),
                            style: .textMain(themeManager.currentThemeStyle)
                        )
                    },
                    style: .themed(themeManager.currentThemeStyle, type: .segmented)
                )
            }
            .padding(.horizontal, 8)
            .background(Color.clear)
        }
    }
    
    /// Returns localized theme name based on theme type.
    private func getLocalizedThemeName(for theme: ThemeType) -> String {
        switch theme {
        case .dark:
            return locale.screenSubtitleThemeDark
        case .light:
            return locale.screenSubtitleThemeLight
        }
    }
}
