import SwiftUI

/// A view that provides category selection filters for a remote dictionary.
///
/// This view allows users to select categories for filtering dictionaries,
/// displaying a loading indicator when categories are being fetched.
struct DictionaryRemoteFilterViewFilter: View {
    
    // MARK: - Properties
    
    /// Manages the application's theme.
    @EnvironmentObject private var themeManager: ThemeManager
    
    /// Fetches categories for filtering.
    @ObservedObject var categoryGetter: CategoryFetcher
    
    /// The selected front category.
    @Binding var selectedFrontCategory: CategoryItem?
    
    /// The selected back category.
    @Binding var selectedBackCategory: CategoryItem?
    
    /// Localization support for UI text.
    private let locale: DictionaryRemoteFilterLocale
    
    // MARK: - Initialization
    
    /// Initializes the view with required dependencies.
    /// - Parameters:
    ///   - categoryGetter: The object responsible for fetching categories.
    ///   - selectedFrontCategory: Binding for the front category selection.
    ///   - selectedBackCategory: Binding for the back category selection.
    ///   - locale: Localization object providing UI text.
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
    
    // MARK: - Body
    
    var body: some View {
        Section() {
            if categoryGetter.isLoadingPage {
                ProgressView()
                    .frame(maxWidth: .infinity)
            } else {
                SectionHeader(
                    title: locale.screenSubtitleLanguage,
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
                .padding(.top, -24)
            }
        }
    }
}
