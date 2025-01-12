import SwiftUI

struct DictionaryLocalListViewSearch: View {
    @Binding var searchText: String
        private let locale: DictionaryLocalListLocale
        
        init(
            searchText: Binding<String>,
            locale: DictionaryLocalListLocale
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
