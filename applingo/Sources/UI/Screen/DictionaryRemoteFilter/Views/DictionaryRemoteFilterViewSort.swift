import SwiftUI

/// A view that allows users to select a sorting option for dictionaries.
///
/// This view provides a segmented picker for sorting dictionaries,
/// with localized labels and theme support.
struct DictionaryRemoteFilterViewSort: View {
    
    // MARK: - Properties
    
    /// The selected sorting option.
    @Binding var selectedSortBy: ApiSortType
    
    /// Localization support for UI text.
    private let locale: DictionaryRemoteFilterLocale
    
    // MARK: - Initialization
    
    /// Initializes the view with required dependencies.
    /// - Parameters:
    ///   - selectedSortBy: Binding for the selected sorting option.
    ///   - locale: Localization object providing UI text.
    init(
        selectedSortBy: Binding<ApiSortType>,
        locale: DictionaryRemoteFilterLocale
    ) {
        self._selectedSortBy = selectedSortBy
        self.locale = locale
    }
    
    // MARK: - Body
    
    var body: some View {
        ItemPicker(
            selectedValue: $selectedSortBy,
            items: ApiSortType.allCases,
            title: locale.screenSubtitleSortBy,
            style: .themed(ThemeManager.shared.currentThemeStyle, type: .segmented)
        ) { sortBy in
            Text(sortBy.name)
        }
    }
}
