import SwiftUI

/// A view that allows users to select a dictionary difficulty level.
///
/// This view provides a picker for selecting a dictionary level,
/// with localized labels and theme support.
struct DictionaryRemoteFilterViewLevel: View {
    // MARK: - Properties
    @EnvironmentObject private var themeManager: ThemeManager
    private let locale: DictionaryRemoteFilterLocale
    private let style: DictionaryRemoteFilterStyle
    
    @Binding var selectedLevel: DictionaryLevelType
    
    // MARK: - Initialization
    /// Initializes the view with required dependencies.
    /// - Parameters:
    ///   - style: `DictionaryRemoteFilterStyle` style configuration.
    ///   - locale: `DictionaryRemoteFilterLocale` localization object.
    ///   - selectedLevel: Binding for the selected dictionary level.
    init(
        style: DictionaryRemoteFilterStyle,
        locale: DictionaryRemoteFilterLocale,
        selectedLevel: Binding<DictionaryLevelType>
    ) {
        self._selectedLevel = selectedLevel
        self.locale = locale
        self.style = style
    }
    
    // MARK: - Body
    var body: some View {
        Section() {
            ItemPicker(
                selectedValue: $selectedLevel,
                items: DictionaryLevelType.allCases,
                title: locale.screenSubtitleLevel,
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
