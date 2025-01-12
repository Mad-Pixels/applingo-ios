import SwiftUI

struct DictionaryListLocalViewSearch: View {
    @Binding var searchText: String
        private let locale: DictionaryListLocalLocale
        
        init(
            searchText: Binding<String>,
            locale: DictionaryListLocalLocale
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
