import SwiftUI

struct DictionaryRemoteListViewSearch: View {
    @Binding var searchText: String
    private let locale: DictionaryRemoteListLocale
    
    init(
        searchText: Binding<String>,
        locale: DictionaryRemoteListLocale
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
