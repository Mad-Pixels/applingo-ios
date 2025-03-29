import SwiftUI

internal struct DictionaryRemoteListViewSearch: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    @Binding var searchText: String
    
    private let locale: DictionaryRemoteListLocale
    private let style: DictionaryRemoteListStyle

    /// Initializes the DictionaryRemoteListViewSearch.
    /// - Parameters:
    ///   - style: `DictionaryRemoteListStyle` object that defines the visual style.
    ///   - locale: `DictionaryRemoteListLocale` object that provides localized strings.
    ///   - searchText: Binding to the search query.
    init(style: DictionaryRemoteListStyle, locale: DictionaryRemoteListLocale, searchText: Binding<String>) {
        self._searchText = searchText
        self.locale = locale
        self.style = style
    }
    
    var body: some View {
        InputSearch(
            text: $searchText,
            placeholder: locale.screenSearch,
            style: .themed(themeManager.currentThemeStyle)
        )
    }
}
