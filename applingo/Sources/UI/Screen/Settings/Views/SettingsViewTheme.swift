import SwiftUI

/// A view that displays the theme selection section in Settings.
struct SettingsViewTheme: View {
    // MARK: - Properties
    @EnvironmentObject private var themeManager: ThemeManager
    private let locale: SettingsLocale
    private let style: SettingsStyle
    
    // MARK: - Initializer
    /// Initializes the word list view with localization and a data source.
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
        ItemPicker(
            selectedValue: $themeManager.currentTheme,
            items: themeManager.supportedThemes,
            title: locale.screenSubtitleTheme,
            style: .themed(themeManager.currentThemeStyle, type: .segmented),
            onChange: { newTheme in themeManager.setTheme(to: newTheme) }
        ) { theme in Text(theme.asString) }
    }
}
