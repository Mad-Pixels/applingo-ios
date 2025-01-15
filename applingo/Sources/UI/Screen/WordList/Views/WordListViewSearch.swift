import SwiftUI

struct WordListViewSearch: View {
    @Binding var searchText: String
    private let locale: WordListLocale
        
    init(
        searchText: Binding<String>,
        locale: WordListLocale
    ) {
        self._searchText = searchText
        self.locale = locale
    }
        
    var body: some View {
        InputSearch(
            text: $searchText,
            placeholder: locale.searchPlaceholder,
            style: .themed(ThemeManager.shared.currentThemeStyle)
        )
    }
}
