import SwiftUI

struct WordListViewSearch: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    @Binding var searchText: String
    
    private let locale: WordListLocale
    private let style: WordListStyle

    internal let isDisabled: Bool

    /// Initializes the WordListViewSearch.
    /// - Parameters:
    ///   - style: A `WordListStyle` object defining the visual style of the view.
    ///   - locale: A `WordListLocale` object providing localized strings for UI elements.
    ///   - searchText: A binding to the search query entered by the user.
    ///   - isDisabled: A Boolean value indicating whether the search functionality is disabled. Default is `false`.
    init(
        style: WordListStyle,
        locale: WordListLocale,
        searchText: Binding<String>,
        isDisabled: Bool = false
    ) {
        self._searchText = searchText
        self.isDisabled = isDisabled
        self.locale = locale
        self.style = style
    }

    var body: some View {
        InputSearch(
            text: $searchText,
            placeholder: locale.screenSearch,
            style: .themed(themeManager.currentThemeStyle),
            isDisabled: isDisabled
        )
    }
}
