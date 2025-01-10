import SwiftUI

struct LocaleSection: View {
    @EnvironmentObject private var localeManager: LocaleManager
    
    private var selectedLocale: Binding<LocaleType> {
        Binding(
            get: { localeManager.currentLocale },
            set: { newValue in
                localeManager.setLocale(newValue)
            }
        )
    }
    
    var body: some View {
        AppPicker(
            selectedValue: selectedLocale,
            items: localeManager.supportedLocales,
            title: LocaleManager.shared.localizedString(for: "language")
        ) { locale in
            Text(locale.displayName)
        }
    }
}
