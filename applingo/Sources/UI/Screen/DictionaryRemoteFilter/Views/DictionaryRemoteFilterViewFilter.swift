import SwiftUI

struct DictionaryRemoteFilterViewFilter: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @ObservedObject var categoryGetter: CategoryFetcher
    @Binding var selectedFrontCategory: CategoryItem?
    @Binding var selectedBackCategory: CategoryItem?
    private let locale: DictionaryRemoteFilterLocale
    
    init(
            categoryGetter: CategoryFetcher,
            selectedFrontCategory: Binding<CategoryItem?>,
            selectedBackCategory: Binding<CategoryItem?>,
            locale: DictionaryRemoteFilterLocale
        ) {
            self.categoryGetter = categoryGetter
            self._selectedFrontCategory = selectedFrontCategory
            self._selectedBackCategory = selectedBackCategory
            self.locale = locale
        }
    
    var body: some View {
        Section(header: Text(locale.dictionaryTitle)) {
            if categoryGetter.isLoadingPage {
                ProgressView()
                    .frame(maxWidth: .infinity)
            } else {
                SectionHeader(
                    title: locale.sortByTitle,
                    style: .titled(themeManager.currentThemeStyle)
                )
                HStack {
                    ItemPicker(
                        selectedValue: $selectedFrontCategory,
                        items: categoryGetter.frontCategories,
                        style: .themed(themeManager.currentThemeStyle)
                    ) { category in
                        Text(category?.code ?? "")
                    }
                    .frame(maxWidth: .infinity)
                    
                    ItemPicker(
                        selectedValue: $selectedBackCategory,
                        items: categoryGetter.backCategories,
                        style: .themed(themeManager.currentThemeStyle)
                    ) { category in
                        Text(category?.code ?? "")
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
    }
}
