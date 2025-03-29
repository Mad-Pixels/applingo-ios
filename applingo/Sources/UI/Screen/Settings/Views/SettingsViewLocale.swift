import SwiftUI

internal struct SettingsViewLocale: View {
    @EnvironmentObject private var localeManager: LocaleManager
    @EnvironmentObject private var themeManager: ThemeManager
    
    private let locale: SettingsLocale
    private let style: SettingsStyle
    
    /// Initializes the SettingsViewLocale.
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
    
    /// Binding to the currently selected locale.
    private var selectedLocale: Binding<LocaleType> {
        Binding(
            get: { localeManager.currentLocale },
            set: { newValue in localeManager.setLocale(newValue) }
        )
    }
    
    var body: some View {
        SectionHeader(
            title: locale.screenSubtitleLanguage,
            style: .block(themeManager.currentThemeStyle)
        )
        ItemPicker(
            selectedValue: selectedLocale,
            items: localeManager.supportedLocales,
            onChange: { newLocale in localeManager.setLocale(newLocale) }
        ) {
            locale in Text(locale.displayName)
        }
    }
}
