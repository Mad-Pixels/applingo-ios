import SwiftUI

internal struct SettingsMainViewLocale: View {
    @EnvironmentObject private var localeManager: LocaleManager
    @EnvironmentObject private var themeManager: ThemeManager
    
    private let locale: SettingsMainLocale
    private let style: SettingsMainStyle
    
    /// Initializes the SettingsMainViewLocale.
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
    
    /// Binding to the currently selected locale.
    private var selectedLocale: Binding<LocaleType> {
        Binding(
            get: { localeManager.currentLocale },
            set: { newValue in localeManager.setLocale(newValue) }
        )
    }
    
    var body: some View {
        VStack(spacing: style.spacing) {
            SectionHeader(
                title: locale.screenSubtitleLanguage,
                style: .block(themeManager.currentThemeStyle)
            )
            .padding(.top, 8)
            
            VStack(spacing: style.spacing) {
                ItemPicker(
                    selectedValue: selectedLocale,
                    items: localeManager.supportedLocales,
                    onChange: { newLocale in localeManager.setLocale(newLocale) }
                ) {
                    locale in Text(locale.displayName.capitalizedFirstLetter)
                }
            }
            .padding(.horizontal, 8)
            .background(Color.clear)
        }
    }
}
