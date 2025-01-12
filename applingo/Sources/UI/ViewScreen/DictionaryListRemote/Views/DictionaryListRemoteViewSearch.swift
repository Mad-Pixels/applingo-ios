import SwiftUI

struct DictionaryListRemoteViewSearch: View {
    @Binding var searchText: String
    private let locale: DictionaryListRemoteLocale
    
    init(
        searchText: Binding<String>,
        locale: DictionaryListRemoteLocale
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
