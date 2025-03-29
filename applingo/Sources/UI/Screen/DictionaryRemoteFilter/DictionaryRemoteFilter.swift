import SwiftUI

/// A view that provides filtering options for remote dictionaries.
///
/// This view allows users to apply filters such as category selection, level,
/// and sorting order while fetching dictionaries from a remote source.
struct DictionaryRemoteFilter: View {
    // MARK: - Properties
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedLevel: DictionaryLevelType = .undefined
    @State private var selectedSortBy: ApiSortType = .date
    
    // MARK: - State Objects
    @StateObject private var locale = DictionaryRemoteFilterLocale()
    @StateObject private var style: DictionaryRemoteFilterStyle
    @StateObject private var categoryGetter = CategoryFetcher()
    
    // MARK: - Local State
    @Binding var apiRequestParams: ApiModelDictionaryQueryRequest
    @State private var selectedFrontCategory: CategoryItem?
    @State private var selectedBackCategory: CategoryItem?
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
        _style = StateObject(wrappedValue: style ?? .themed(ThemeManager.shared.currentThemeStyle))
        self._apiRequestParams = apiRequestParams
       
        if let level = apiRequestParams.wrappedValue.level {
            _selectedLevel = State(initialValue: DictionaryLevelType(rawValue: level) ?? .undefined)
        }
        
        if let sortBy = apiRequestParams.wrappedValue.sortBy {
            _selectedSortBy = State(initialValue: sortBy == "rating" ? .rating : .date)
        }
        
        if let subcategory = apiRequestParams.wrappedValue.subcategory {
            let parts = subcategory.split(separator: "-")
            if parts.count == 2 {
                let frontCode = String(parts[0])
                let backCode = String(parts[1])
                _selectedFrontCategory = State(initialValue: CategoryItem(code: frontCode))
                _selectedBackCategory = State(initialValue: CategoryItem(code: backCode))
            }
        }
    }
    
    // MARK: - Body
    var body: some View {
        BaseScreen(
            screen: .DictionaryRemoteFilter,
            title: locale.screenTitle
        ) {
            ScrollView {
                if categoryGetter.isLoadingPage { 
                    VStack {
                        Spacer()
                        ItemListLoading(style: .themed(ThemeManager.shared.currentThemeStyle))
                        Spacer()
                    }
                    .frame(minHeight: UIScreen.main.bounds.height - 200)
                } else {
                    VStack(spacing: style.spacing) {
                        DictionaryRemoteFilterViewFilter(
                            style: style,
                            locale: locale,
                            categoryGetter: categoryGetter,
                            selectedFrontCategory: $selectedFrontCategory,
                            selectedBackCategory: $selectedBackCategory
                        )
                        .padding(style.padding)
                            
                        DictionaryRemoteFilterViewSort(
                            style: style,
                            locale: locale,
                            selectedSortBy: $selectedSortBy
                        )
                        .padding(style.padding)
                            
                        DictionaryRemoteFilterViewLevel(
                            style: style,
                            locale: locale,
                            selectedLevel: $selectedLevel
                        )
                        .padding(style.padding)
                    }
                    .padding(style.padding)
                }
            }
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
            if selectedFrontCategory == nil || !frontCategories.contains(where: { $0.code == selectedFrontCategory?.code }) {
                selectedFrontCategory = frontCategories.first
            }
        }
        .onChange(of: categoryGetter.backCategories) { backCategories in
            if selectedBackCategory == nil || !backCategories.contains(where: { $0.code == selectedBackCategory?.code }) {
                selectedBackCategory = backCategories.first
            }
        }
        
        DictionaryRemoteFilterViewActions(
            style: style,
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
        apiRequestParams.level = selectedLevel == .undefined ? nil : selectedLevel.rawValue
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
