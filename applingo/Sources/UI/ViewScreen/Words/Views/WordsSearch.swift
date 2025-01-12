import SwiftUI

struct WordsSearch: View {
    @Binding var searchText: String
        private let locale: ScreenWordsLocale
        
        init(
            searchText: Binding<String>,
            locale: ScreenWordsLocale
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
