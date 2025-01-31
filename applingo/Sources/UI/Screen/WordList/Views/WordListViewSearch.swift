import SwiftUI

/// A view that provides a search bar for filtering words.
struct WordListViewSearch: View {
    
    // MARK: - Properties
    
    /// Binding to the search text.
    @Binding var searchText: String
    private let locale: WordListLocale
    
    // MARK: - Initializer
    
    /// Initializes the search view with a binding to the search query and localization.
    /// - Parameters:
    ///   - searchText: Binding to the search query.
    ///   - locale: Localization object.
    init(
        searchText: Binding<String>,
        locale: WordListLocale
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
