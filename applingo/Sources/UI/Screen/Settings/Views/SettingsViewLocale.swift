import SwiftUI

/// A view that displays the language selection section in Settings.
struct SettingsViewLocale: View {
    // MARK: - Properties
    @EnvironmentObject private var themeManager: ThemeManager
    private let locale: SettingsLocale
    private let style: SettingsStyle
    
    @EnvironmentObject private var localeManager: LocaleManager
    
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
    
    // MARK: - Private Methods
    /// Binding to the currently selected locale.
    private var selectedLocale: Binding<LocaleType> {
        Binding(
            get: { localeManager.currentLocale },
            set: { newValue in localeManager.setLocale(newValue) }
        )
    }
    
    // MARK: - Body
    var body: some View {
        ItemPicker(
            selectedValue: selectedLocale,
            items: localeManager.supportedLocales,
            title: locale.screenSubtitleLanguage,
            style: .themed(themeManager.currentThemeStyle),
            onChange: { newLocale in localeManager.setLocale(newLocale) }
        ) { locale in Text(locale.displayName) }
    }
}
