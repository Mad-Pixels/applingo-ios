import SwiftUI

/// A view that allows users to select a dictionary difficulty level.
///
/// This view provides a picker for selecting a dictionary level,
/// with localized labels and theme support.
struct DictionaryRemoteFilterViewLevel: View {
    
    // MARK: - Properties
    
    /// Manages the application's theme.
    @EnvironmentObject private var themeManager: ThemeManager
    
    /// The selected dictionary level.
    @Binding var selectedLevel: DictionaryLevelType
    
    /// Localization support for UI text.
    private let locale: DictionaryRemoteFilterLocale
    
    // MARK: - Initialization
    
    /// Initializes the view with required dependencies.
    /// - Parameters:
    ///   - selectedLevel: Binding for the selected dictionary level.
    ///   - locale: Localization object providing UI text.
    init(
        selectedLevel: Binding<DictionaryLevelType>,
        locale: DictionaryRemoteFilterLocale
    ) {
        self._selectedLevel = selectedLevel
        self.locale = locale
    }
    
    // MARK: - Body
    
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
