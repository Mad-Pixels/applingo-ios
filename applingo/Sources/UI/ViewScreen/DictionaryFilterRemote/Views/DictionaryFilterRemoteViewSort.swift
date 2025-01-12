import SwiftUI

struct DictionaryFilterRemoteViewSort: View {
    @Binding var selectedSortBy: ApiDictionaryQueryRequestModel.SortBy
    private let locale: DictionaryFilterRemoteLocale
    
    init(
            selectedSortBy: Binding<ApiDictionaryQueryRequestModel.SortBy>,
            locale: DictionaryFilterRemoteLocale
        ) {
            self._selectedSortBy = selectedSortBy
            self.locale = locale
        }
    
    var body: some View {
        ItemPicker(
            selectedValue: $selectedSortBy,
            items: ApiDictionaryQueryRequestModel.SortBy.allCases,
            title: locale.sortByTitle,
            style: .themed(ThemeManager.shared.currentThemeStyle, type: .segmented)
        ) { sortBy in
            Text(sortBy.displayName)
        }
    }
}
