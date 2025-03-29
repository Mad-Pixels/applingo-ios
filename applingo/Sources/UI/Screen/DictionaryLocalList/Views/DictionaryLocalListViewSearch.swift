import SwiftUI

internal struct DictionaryLocalListViewSearch: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    @Binding var searchText: String
    
    private let locale: DictionaryLocalListLocale
    private let style: DictionaryLocalListStyle
    
    /// Initializes the DictionaryLocalListViewSearch.
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
    
    var body: some View {
        InputSearch(
            text: $searchText,
            placeholder: locale.screenSearch,
            style: .themed(themeManager.currentThemeStyle)
        )
    }
}
