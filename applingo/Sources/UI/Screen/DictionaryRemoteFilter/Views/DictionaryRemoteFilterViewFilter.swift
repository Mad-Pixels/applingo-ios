import SwiftUI

internal struct DictionaryRemoteFilterViewFilter: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    @Binding var selectedFrontCategory: CategoryItem?
    @Binding var selectedBackCategory: CategoryItem?
    
    @ObservedObject var categoryGetter: CategoryFetcher
    
    private let locale: DictionaryRemoteFilterLocale
    private let style: DictionaryRemoteFilterStyle
    
    /// Initializes the DictionaryRemoteFilterViewFilter.
    /// - Parameters:
    ///   - style: `DictionaryRemoteFilterStyle` style configuration.
    ///   - locale: `DictionaryRemoteFilterLocale` localization object.
    ///   - categoryGetter: The object responsible for fetching categories.
    ///   - selectedFrontCategory: Binding for the front category selection.
    ///   - selectedBackCategory: Binding for the back category selection.
    init(
        style: DictionaryRemoteFilterStyle,
        locale: DictionaryRemoteFilterLocale,
        categoryGetter: CategoryFetcher,
        selectedFrontCategory: Binding<CategoryItem?>,
        selectedBackCategory: Binding<CategoryItem?>
    ) {
        self._selectedFrontCategory = selectedFrontCategory
        self._selectedBackCategory = selectedBackCategory
        self.categoryGetter = categoryGetter
        self.locale = locale
        self.style = style
    }
    
    var body: some View {
        Section() {
            SectionHeader(
                title: locale.screenSubtitleLanguage,
                style: .block(themeManager.currentThemeStyle)
            )
            HStack {
                ItemPicker(
                    selectedValue: $selectedFrontCategory,
                    items: categoryGetter.frontCategories,
                    content:  {
                        category in Text(category?.code ?? "")
                    },
                    style: .themed(themeManager.currentThemeStyle)
                )
                .frame(maxWidth: .infinity)
                    
                ItemPicker(
                    selectedValue: $selectedBackCategory,
                    items: categoryGetter.backCategories,
                    content:  {
                        category in Text(category?.code ?? "")
                    },
                    style: .themed(themeManager.currentThemeStyle)
                )
                .frame(maxWidth: .infinity)
            }
            .padding(.top, -24)
        }
    }
}
