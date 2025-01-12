import SwiftUI

struct SettingsViewLocale: View {
    @EnvironmentObject private var localeManager: LocaleManager
    @Environment(\.settingsLocale) private var locale
    
    private var selectedLocale: Binding<LocaleType> {
        Binding(
            get: { localeManager.currentLocale },
            set: { newValue in
                localeManager.setLocale(newValue)
            }
        )
    }
    
    var body: some View {
        ItemPicker(
            selectedValue: selectedLocale,
            items: localeManager.supportedLocales,
            title: locale.languageTitle,
            style: .themed(ThemeManager.shared.currentThemeStyle),
            onChange: { newLocale in
                localeManager.setLocale(newLocale)
            }
        ) { locale in
            Text(locale.displayName)
        }
    }
}
