import SwiftUI

struct DictionaryFilterRemoteViewSection: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @ObservedObject var categoryGetter: CategoryRemoteGetterViewModel
    @Binding var selectedFrontCategory: CategoryItem?
    @Binding var selectedBackCategory: CategoryItem?
    private let locale: DictionaryFilterRemoteLocale
    
    init(
            categoryGetter: CategoryRemoteGetterViewModel,
            selectedFrontCategory: Binding<CategoryItem?>,
            selectedBackCategory: Binding<CategoryItem?>,
            locale: DictionaryFilterRemoteLocale
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
                HStack {
                    ItemPicker(
                        selectedValue: $selectedFrontCategory,
                        items: categoryGetter.frontCategories,
                        style: .themed(themeManager.currentThemeStyle)
                    ) { category in
                        Text(category?.code ?? "")
                    }
                    .frame(maxWidth: .infinity)
                    
                    // Стрелка между пикерами
                    //ArrowDivider()
                    
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
