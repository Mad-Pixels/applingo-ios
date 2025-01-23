import SwiftUI

struct DictionaryRemoteFilterViewSort: View {
    @Binding var selectedSortBy: ApiDictionaryQueryRequestModel.SortBy
    private let locale: DictionaryRemoteFilterLocale
    
    init(
            selectedSortBy: Binding<ApiDictionaryQueryRequestModel.SortBy>,
            locale: DictionaryRemoteFilterLocale
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
            Text(sortBy.name)
        }
    }
}
