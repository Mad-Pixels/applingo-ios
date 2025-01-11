import SwiftUI

struct DictionariesLocalSearch: View {
    @Binding var searchText: String
        private let locale: ScreenDictionariesLocalLocale
        
        init(
            searchText: Binding<String>,
            locale: ScreenDictionariesLocalLocale
        ) {
            self._searchText = searchText
            self.locale = locale
        }
        
        var body: some View {
            AppSearch(
                text: $searchText,
                placeholder: locale.searchPlaceholder,
                style: .themed(ThemeManager.shared.currentThemeStyle)
            )
        }
}
