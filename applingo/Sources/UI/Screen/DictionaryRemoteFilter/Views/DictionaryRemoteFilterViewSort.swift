import SwiftUI

struct DictionaryRemoteFilterViewSort: View {
    @Binding var selectedSortBy: ApiSortType
    private let locale: DictionaryRemoteFilterLocale
   
    init(
        selectedSortBy: Binding<ApiSortType>,
        locale: DictionaryRemoteFilterLocale
    ) {
        self._selectedSortBy = selectedSortBy
        self.locale = locale
    }
   
    var body: some View {
        ItemPicker(
            selectedValue: $selectedSortBy,
            items: ApiSortType.allCases,
            title: locale.sortByTitle,
            style: .themed(ThemeManager.shared.currentThemeStyle, type: .segmented)
        ) { sortBy in
            Text(sortBy.name)
        }
    }
}
