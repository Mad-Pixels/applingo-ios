import SwiftUI

internal struct SettingsMainViewLocale: View {
    @EnvironmentObject private var localeManager: LocaleManager
    @EnvironmentObject private var themeManager: ThemeManager

    @ObservedObject private var locale: SettingsMainLocale
    @State private var selectedLocale: LocaleType

    private let style: SettingsMainStyle

    init(
        style: SettingsMainStyle,
        locale: SettingsMainLocale
    ) {
        self.locale = locale
        self.style = style
        _selectedLocale = State(initialValue: LocaleManager.shared.currentLocale)
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
                    selectedValue: $selectedLocale,
                    items: localeManager.supportedLocales,
                    onChange: { newLocale in
                        selectedLocale = newLocale
                        localeManager.setLocale(newLocale)
                    }
                ) { locale in
                    Text(locale.displayName.capitalizedFirstLetter)
                }
                .id(UUID())
            }
            .padding(.horizontal, 8)
            .background(Color.clear)
        }
        .onReceive(localeManager.$currentLocale) { new in
            if new != selectedLocale && localeManager.supportedLocales.contains(new) {
                selectedLocale = new
            }
        }
    }
}
