import SwiftUI

struct LocaleSection: View {
    @EnvironmentObject private var localeManager: LocaleManager
    
    private var selectedLocale: Binding<LocaleType> {
        Binding(
            get: { localeManager.currentLocale },
            set: { newValue in
                Logger.debug("[LocaleSection]: Selected new locale: \(newValue.asString)")
                localeManager.setLocale(newValue)
            }
        )
    }
    
    var body: some View {
        AppPicker(
            selectedValue: selectedLocale,
            items: localeManager.supportedLocales,
            title: LocaleManager.shared.localizedString(for: "language"),
            style: .default
        ) { locale in
            Text(locale.displayName)
        }
        .id(localeManager.viewId) // Перенесли id на весь AppPicker
        .onChange(of: localeManager.currentLocale) { newValue in
            Logger.debug("[LocaleSection]: Locale changed to: \(newValue.asString)")
        }
    }
}
