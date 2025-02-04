import SwiftUI

/// A view that displays the language selection section in Settings.
struct SettingsViewLocale: View {
    
    // MARK: - Environment and State Objects
    
    @EnvironmentObject private var localeManager: LocaleManager
    @StateObject private var locale = SettingsLocale()
    
    // MARK: - Helper Binding
    
    /// Binding to the currently selected locale.
    private var selectedLocale: Binding<LocaleType> {
        Binding(
            get: { localeManager.currentLocale },
            set: { newValue in
                localeManager.setLocale(newValue)
            }
        )
    }
    
    // MARK: - Body
    
    var body: some View {
        ItemPicker(
            selectedValue: selectedLocale,
            items: localeManager.supportedLocales,
            title: locale.screenSubtitleLanguage,
            style: .themed(ThemeManager.shared.currentThemeStyle),
            onChange: { newLocale in
                localeManager.setLocale(newLocale)
            }
        ) { locale in
            Text(locale.displayName)
        }
    }
}
