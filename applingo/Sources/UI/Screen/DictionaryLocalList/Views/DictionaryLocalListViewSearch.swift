import SwiftUI

/// A view that provides a search input for filtering dictionaries.
struct DictionaryLocalListViewSearch: View {
    
    // MARK: - Properties
    
    @Binding var searchText: String
    private let locale: DictionaryLocalListLocale
    
    // MARK: - Initializer
    
    /// Initializes the search view with a binding to search text and localization.
    /// - Parameters:
    ///   - searchText: A binding for the search query.
    ///   - locale: The localization object.
    init(
        searchText: Binding<String>,
        locale: DictionaryLocalListLocale
    ) {
        self._searchText = searchText
        self.locale = locale
    }
    
    // MARK: - Body
    
    var body: some View {
        InputSearch(
            text: $searchText,
            placeholder: locale.searchPlaceholder,
            style: .themed(ThemeManager.shared.currentThemeStyle)
        )
    }
}
