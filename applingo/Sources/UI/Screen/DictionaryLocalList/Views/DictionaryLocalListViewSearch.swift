import SwiftUI

/// A view that provides a search input for filtering dictionaries.
struct DictionaryLocalListViewSearch: View {
    // MARK: - Properties
    @EnvironmentObject private var themeManager: ThemeManager
    private let locale: DictionaryLocalListLocale
    private let style: DictionaryLocalListStyle
    
    @Binding var searchText: String
    
    // MARK: - Initializer
    /// Initializes a new instance of `WordListViewWelcome`.
    /// - Parameters:
    ///   - style: `DictionaryLocalListStyle` object that defines the visual style.
    ///   - locale: `DictionaryLocalListLocale` object that provides localized strings.
    ///   - searchText: Binding to the search query.
    init(
        style: DictionaryLocalListStyle,
        locale: DictionaryLocalListLocale,
        searchText: Binding<String>
    ) {
        self._searchText = searchText
        self.locale = locale
        self.style = style
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
