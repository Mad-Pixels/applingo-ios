import SwiftUI

/// A view that provides a search bar for filtering words.
struct WordListViewSearch: View {
    // MARK: - Properties
    @EnvironmentObject private var themeManager: ThemeManager
    private let locale: WordListLocale
    
    /// Binding to the search text.
    @Binding var searchText: String
    
    // MARK: - Initializer
    
    /// Initializes the search view with a binding to the search query and localization.
    /// - Parameters:
    ///   - searchText: Binding to the search query.
    ///   - locale: Localization object.
    init(searchText: Binding<String>, locale: WordListLocale) {
        self._searchText = searchText
        self.locale = locale
    }
    
    // MARK: - Body
    var body: some View {
        InputSearch(
            text: $searchText,
            placeholder: locale.screenSearch,
            style: .themed(themeManager.currentThemeStyle)
        )
    }
}
