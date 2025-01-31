import SwiftUI

/// A view that provides a search input field for filtering remote dictionaries.
struct DictionaryRemoteListViewSearch: View {
    
    // MARK: - Properties
    
    @Binding var searchText: String
    private let locale: DictionaryRemoteListLocale
    
    // MARK: - Initializer
    
    /// Initializes the search view with a binding for the search text and localization.
    /// - Parameters:
    ///   - searchText: A binding to the search query.
    ///   - locale: The localization object.
    init(
        searchText: Binding<String>,
        locale: DictionaryRemoteListLocale
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
