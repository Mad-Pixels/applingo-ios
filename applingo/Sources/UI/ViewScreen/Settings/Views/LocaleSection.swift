import SwiftUI

 struct LocaleSection: View {
    @EnvironmentObject private var localeManager: LocaleManager
    
    // Используем computed property вместо state
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
            title: "language",
            style: .default
        ) { locale in
            Text(locale.displayName)
                .id(localeManager.viewId)
        }
        .onChange(of: localeManager.currentLocale) { newValue in
            Logger.debug("[LocaleSection]: Locale changed to: \(newValue.asString)")
        }
    }
}
