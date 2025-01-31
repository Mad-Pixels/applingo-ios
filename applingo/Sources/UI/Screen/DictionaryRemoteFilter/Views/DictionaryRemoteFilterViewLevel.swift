import SwiftUI

struct DictionaryRemoteFilterViewLevel: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @Binding var selectedLevel: DictionaryLevelType
    private let locale: DictionaryRemoteFilterLocale
    
    init(
        selectedLevel: Binding<DictionaryLevelType>,
        locale: DictionaryRemoteFilterLocale
    ) {
        self._selectedLevel = selectedLevel
        self.locale = locale
    }
    
    var body: some View {
        Section(header: Text(locale.levelTitle)) {
            ItemPicker(
                selectedValue: $selectedLevel,
                items: DictionaryLevelType.allCases,
                style: .themed(themeManager.currentThemeStyle)
            ) { level in
                Text(level.rawValue == "UFO"
                    ? LocaleManager.shared.localizedString(for: "Undefined")
                    : level.rawValue)
            }
            .frame(maxWidth: .infinity)
        }
    }
}
