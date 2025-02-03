import SwiftUI

/// A view that provides filtering options for remote dictionaries.
///
/// This view allows users to apply filters such as category selection, level,
/// and sorting order while fetching dictionaries from a remote source.
struct DictionaryRemoteFilter: View {
    
    // MARK: - Properties
    
    /// Manages the presentation mode.
    @Environment(\.presentationMode) var presentationMode
    
    /// Stores the UI style of the filter view.
    @StateObject private var style: DictionaryRemoteFilterStyle
    
    /// Stores the localization settings.
    @StateObject private var locale = DictionaryRemoteFilterLocale()
    
    /// Fetches category data.
    @StateObject private var categoryGetter = CategoryFetcher()
    
    /// API request parameters for filtering dictionaries.
    @Binding var apiRequestParams: ApiModelDictionaryQueryRequest
    
    /// The selected dictionary level.
    @State private var selectedLevel: DictionaryLevelType = .undefined
    
    /// The selected sorting option.
    @State private var selectedSortBy: ApiSortType = .date
    
    /// The selected front category.
    @State private var selectedFrontCategory: CategoryItem?
    
    /// The selected back category.
    @State private var selectedBackCategory: CategoryItem?
    
    /// State to track the button press.
    @State private var isPressedTrailing = false
    
    // MARK: - Initialization
    
    /// Initializes the view with required dependencies.
    /// - Parameters:
    ///   - apiRequestParams: Binding for API request parameters.
    ///   - style: Optional style for the filter UI.
    init(
        apiRequestParams: Binding<ApiModelDictionaryQueryRequest>,
        style: DictionaryRemoteFilterStyle? = nil
    ) {
        self._apiRequestParams = apiRequestParams
        let initialStyle = style ?? .themed(ThemeManager.shared.currentThemeStyle)
        _style = StateObject(wrappedValue: initialStyle)
        
        if let level = apiRequestParams.wrappedValue.level {
            _selectedLevel = State(initialValue: DictionaryLevelType(rawValue: level) ?? .undefined)
        }
        
        if let sortBy = apiRequestParams.wrappedValue.sortBy {
            _selectedSortBy = State(initialValue: sortBy == "rating" ? .rating : .date)
        }
    }
    
    // MARK: - Body
    
    var body: some View {
        BaseScreen(
            screen: .DictionaryRemoteFilter,
            title: locale.navigationTitle
        ) {
            ScrollView {
                VStack(spacing: style.spacing) {
                    DictionaryRemoteFilterViewFilter(
                        categoryGetter: categoryGetter,
                        selectedFrontCategory: $selectedFrontCategory,
                        selectedBackCategory: $selectedBackCategory,
                        locale: locale
                    )
                    .padding(style.padding)

                    DictionaryRemoteFilterViewSort(
                        selectedSortBy: $selectedSortBy,
                        locale: locale
                    )
                    .padding(style.padding)
                    
                    DictionaryRemoteFilterViewLevel(
                        selectedLevel: $selectedLevel,
                        locale: locale
                    )
                    .padding(style.padding)
                }
                .padding(style.padding)
            }
            .navigationTitle(locale.navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    ButtonNav(
                        style: .close(ThemeManager.shared.currentThemeStyle),
                        onTap: {
                            presentationMode.wrappedValue.dismiss()
                        },
                        isPressed: $isPressedTrailing
                    )
                }
            }
        }
        .onAppear {
            categoryGetter.setScreen(.DictionaryRemoteFilter)
            categoryGetter.get { _ in }
        }
        .onChange(of: categoryGetter.frontCategories) { frontCategories in
            if selectedFrontCategory == nil, let firstCategory = frontCategories.first {
                selectedFrontCategory = firstCategory
            }
        }
        .onChange(of: categoryGetter.backCategories) { backCategories in
            if selectedBackCategory == nil, let firstCategory = backCategories.first {
                selectedBackCategory = firstCategory
            }
        }
        
        DictionaryRemoteFilterViewActions(
            locale: locale,
            onSave: saveFilters,
            onReset: resetFilters
        )
    }
    
    // MARK: - Private Methods
    
    /// Saves the selected filters and updates the API request parameters.
    private func saveFilters() {
       let frontCategoryName = selectedFrontCategory?.code ?? ""
       let backCategoryName = selectedBackCategory?.code ?? ""
       apiRequestParams.subcategory = "\(frontCategoryName)-\(backCategoryName)".lowercased()
       apiRequestParams.sortBy = selectedSortBy.rawValue
       apiRequestParams.level = selectedLevel.rawValue
       presentationMode.wrappedValue.dismiss()
    }
    
    /// Resets all selected filters to their default values.
    private func resetFilters() {
        apiRequestParams.subcategory = nil
        apiRequestParams.sortBy = nil
        apiRequestParams.level = nil
        selectedLevel = .undefined
        Logger.debug("Filters reset: all parameters cleared")
        presentationMode.wrappedValue.dismiss()
    }
}
