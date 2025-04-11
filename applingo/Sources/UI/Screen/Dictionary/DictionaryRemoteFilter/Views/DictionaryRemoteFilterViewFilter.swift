import SwiftUI

internal struct DictionaryRemoteFilterViewFilter: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    @Binding var selectedFrontCategory: CategoryItem?
    @Binding var selectedBackCategory: CategoryItem?
    
    @ObservedObject var categoryGetter: CategoryFetcher
    
    private let locale: DictionaryRemoteFilterLocale
    private let style: DictionaryRemoteFilterStyle
    
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
        VStack(spacing: style.spacing) {
            SectionHeader(
                title: locale.screenSubtitleLanguage,
                style: .block(themeManager.currentThemeStyle)
            )
            .padding(.top, 8)
            
            HStack(spacing: style.spacing) {
                ItemPicker(
                    selectedValue: $selectedFrontCategory,
                    items: categoryGetter.backCategories,
                    content: { category in
                        DynamicText(
                            model: DynamicTextModel(text: getLocalizedCategoryText(for: category).capitalizedFirstLetter),
                            style: .picker(themeManager.currentThemeStyle, fontSize: 13)
                        )
                    },
                    style: .themed(themeManager.currentThemeStyle)
                )
                .frame(maxWidth: .infinity)
                    
                ItemPicker(
                    selectedValue: $selectedBackCategory,
                    items: categoryGetter.backCategories,
                    content: { category in
                        DynamicText(
                            model: DynamicTextModel(text: getLocalizedCategoryText(for: category).capitalizedFirstLetter),
                            style: .picker(themeManager.currentThemeStyle, fontSize: 13)
                        )
                    },
                    style: .themed(themeManager.currentThemeStyle)
                )
                .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 8)
            .background(Color.clear)
        }
    }
    
    /// Returns a localized category label with language name and code.
    private func getLocalizedCategoryText(for category: CategoryItem?) -> String {
        guard let category else {
            return locale.screenTextUFOLevel
        }
        let localizedName = locale.localizedCategoryName(for: category.code)
        return "\(localizedName) (\(category.code.uppercased()))"
    }
}
