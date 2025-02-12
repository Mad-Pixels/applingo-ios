import SwiftUI

/// A view that provides a search input field for filtering remote dictionaries.
struct DictionaryRemoteListViewSearch: View {
    // MARK: - Properties
    @EnvironmentObject private var themeManager: ThemeManager
    private let locale: DictionaryRemoteListLocale
    private let style: DictionaryRemoteListStyle

    @Binding var searchText: String

    // MARK: - Initializer
    /// Initializes a new instance of `WordListViewWelcome`.
    /// - Parameters:
    ///   - style: `DictionaryRemoteListStyle` object that defines the visual style.
    ///   - locale: `DictionaryRemoteListLocale` object that provides localized strings.
    ///   - searchText: Binding to the search query.
    init(style: DictionaryRemoteListStyle, locale: DictionaryRemoteListLocale, searchText: Binding<String>) {
        self._searchText = searchText
        self.locale = locale
        self.style = style
    }
    
    // MARK: - Body
    var body: some View {
        InputSearch(
            text: $searchText,
            placeholder: locale.screenSearch,
            style: .themed(ThemeManager.shared.currentThemeStyle)
        )
    }
}
