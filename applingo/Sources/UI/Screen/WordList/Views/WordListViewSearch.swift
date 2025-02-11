import SwiftUI

/// A view that provides a search bar for filtering words.
struct WordListViewSearch: View {
    // MARK: - Properties
    @EnvironmentObject private var themeManager: ThemeManager
    private let locale: WordListLocale
    private let style: WordListStyle

    @Binding var searchText: String

    // MARK: - Initializer
    /// Initializes a new instance of `WordListViewWelcome`.
    /// - Parameters:
    ///   - style: `WordListStyle` object that defines the visual style.
    ///   - locale: `WordListLocale` object that provides localized strings.
    ///   - searchText: Binding to the search query.
    init(style: WordListStyle, locale: WordListLocale, searchText: Binding<String>) {
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
