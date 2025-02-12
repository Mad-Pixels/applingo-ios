import SwiftUI

/// A view that provides category selection filters for a remote dictionary.
///
/// This view allows users to select categories for filtering dictionaries,
/// displaying a loading indicator when categories are being fetched.
struct DictionaryRemoteFilterViewFilter: View {
    // MARK: - Properties
    @EnvironmentObject private var themeManager: ThemeManager
    private let locale: DictionaryRemoteFilterLocale
    private let style: DictionaryRemoteFilterStyle

    @ObservedObject var categoryGetter: CategoryFetcher
    @Binding var selectedFrontCategory: CategoryItem?
    @Binding var selectedBackCategory: CategoryItem?

    // MARK: - Initialization
    /// Initializes the view with required dependencies.
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
    
    // MARK: - Body
    var body: some View {
        Section() {
            SectionHeader(
                title: locale.screenSubtitleLanguage,
                style: .titled(themeManager.currentThemeStyle)
            )
            HStack {
                ItemPicker(
                    selectedValue: $selectedFrontCategory,
                    items: categoryGetter.frontCategories,
                    style: .themed(themeManager.currentThemeStyle)
                ) {
                    category in Text(category?.code ?? "")
                }
                .frame(maxWidth: .infinity)
                    
                ItemPicker(
                    selectedValue: $selectedBackCategory,
                    items: categoryGetter.backCategories,
                    style: .themed(themeManager.currentThemeStyle)
                ) {
                    category in Text(category?.code ?? "")
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.top, -24)
        }
    }
}
