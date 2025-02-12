import SwiftUI

/// A view that allows users to select a sorting option for dictionaries.
///
/// This view provides a segmented picker for sorting dictionaries,
/// with localized labels and theme support.
struct DictionaryRemoteFilterViewSort: View {
    // MARK: - Properties
    @EnvironmentObject private var themeManager: ThemeManager
    private let locale: DictionaryRemoteFilterLocale
    private let style: DictionaryRemoteFilterStyle
    
    @Binding var selectedSortBy: ApiSortType
    
    // MARK: - Initialization
    /// Initializes the view with required dependencies.
    /// - Parameters:
    ///   - style: `DictionaryRemoteFilterStyle` style configuration.
    ///   - locale: `DictionaryRemoteFilterLocale` localization object.
    ///   - selectedSortBy: Binding for the selected sorting option.
    init(
        style: DictionaryRemoteFilterStyle,
        locale: DictionaryRemoteFilterLocale,
        selectedSortBy: Binding<ApiSortType>
    ) {
        self._selectedSortBy = selectedSortBy
        self.locale = locale
        self.style = style
    }
    
    // MARK: - Body
    var body: some View {
        ItemPicker(
            selectedValue: $selectedSortBy,
            items: ApiSortType.allCases,
            title: locale.screenSubtitleSortBy,
            style: .themed(ThemeManager.shared.currentThemeStyle, type: .segmented)
        ) { sortBy in Text(sortBy.name) }
    }
}
