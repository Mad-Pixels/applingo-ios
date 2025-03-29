import SwiftUI

internal struct SettingsViewTheme: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    @ObservedObject private var locale: SettingsLocale
    
    private let style: SettingsStyle
    
    /// Initializes the SettingsViewTheme.
    /// - Parameters:
    ///   - style: `SettingsStyle` object that defines the visual style.
    ///   - locale: `SettingsLocale` object that provides localized strings.
    init(
        style: SettingsStyle,
        locale: SettingsLocale
    ) {
        self.locale = locale
        self.style = style
    }
    
    // MARK: - Body
    var body: some View {
        SectionHeader(
            title: locale.screenSubtitleTheme,
            style: .block(ThemeManager.shared.currentThemeStyle)
        )
        ItemPicker(
            selectedValue: $themeManager.currentTheme,
            items: themeManager.supportedThemes,
            onChange: { newTheme in themeManager.setTheme(to: newTheme) },
            content:  {
                theme in Text(theme.asString)
            },
            style: .themed(themeManager.currentThemeStyle, type: .segmented)
        )
    }
}
