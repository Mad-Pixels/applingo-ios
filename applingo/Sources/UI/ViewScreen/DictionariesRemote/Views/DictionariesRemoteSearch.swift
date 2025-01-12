import SwiftUI

struct DictionariesRemoteSearch: View {
    @Binding var searchText: String
    private let locale: ScreenDictionariesRemoteLocale
    
    init(
        searchText: Binding<String>,
        locale: ScreenDictionariesRemoteLocale
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
