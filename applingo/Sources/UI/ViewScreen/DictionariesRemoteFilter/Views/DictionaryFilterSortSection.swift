import SwiftUI

struct DictionaryFilterSortSection: View {
    @Binding var selectedSortBy: ApiDictionaryQueryRequestModel.SortBy
    private let locale: ScreenDictionaryFilterLocale
    
    init(
            selectedSortBy: Binding<ApiDictionaryQueryRequestModel.SortBy>,
            locale: ScreenDictionaryFilterLocale
        ) {
            self._selectedSortBy = selectedSortBy
            self.locale = locale
        }
    
    var body: some View {
        AppPicker(
            selectedValue: $selectedSortBy,
            items: ApiDictionaryQueryRequestModel.SortBy.allCases,
            title: locale.sortByTitle,
            style: .themed(ThemeManager.shared.currentThemeStyle, type: .segmented)
        ) { sortBy in
            Text(sortBy.displayName)
        }
    }
}
