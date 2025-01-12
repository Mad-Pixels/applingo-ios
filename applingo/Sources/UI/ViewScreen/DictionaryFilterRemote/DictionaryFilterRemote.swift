import SwiftUI

struct DictionaryFilterRemote: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var style: DictionaryFilterRemoteStyle
    @StateObject private var locale = DictionaryFilterRemoteLocale()
    @StateObject private var categoryGetter = CategoryRemoteGetterViewModel()
    
    @Binding var apiRequestParams: ApiDictionaryQueryRequestModel
    @State private var selectedFrontCategory: CategoryItem?
    @State private var selectedBackCategory: CategoryItem?
    @State private var selectedSortBy: ApiDictionaryQueryRequestModel.SortBy = .date
    
    init(
        apiRequestParams: Binding<ApiDictionaryQueryRequestModel>,
        style: DictionaryFilterRemoteStyle? = nil
    ) {
        self._apiRequestParams = apiRequestParams
        let initialStyle = style ?? .themed(ThemeManager.shared.currentThemeStyle)
        _style = StateObject(wrappedValue: initialStyle)
        
        if let sortBy = apiRequestParams.wrappedValue.sortBy {
            _selectedSortBy = State(initialValue: sortBy == "rating" ? .rating : .date)
        }
    }
    
    var body: some View {
        BaseViewScreen(screen: .dictionariesRemoteFilter) {
            VStack(spacing: 0) {
                Form {
                    DictionaryFilterRemoteViewSection(
                        categoryGetter: categoryGetter,
                        selectedFrontCategory: $selectedFrontCategory,
                        selectedBackCategory: $selectedBackCategory,
                        locale: locale
                    )
                            
                    DictionaryFilterRemoteViewSort(
                        selectedSortBy: $selectedSortBy,
                        locale: locale
                    )
                }
                    
                DictionaryFilterRemoteViewActions(
                    locale: locale,
                    onSave: saveFilters,
                    onReset: resetFilters
                )
            }
            .navigationTitle(locale.navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                trailing: Button(locale.closeTitle) {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
        .navigationTitle(locale.navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(
            trailing: Button(locale.closeTitle) {
                presentationMode.wrappedValue.dismiss()
            }
        )
        .onAppear {
            categoryGetter.setFrame(.dictionaryRemoteFilter)
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
    }
    
    private func saveFilters() {
        let frontCategoryName = selectedFrontCategory?.code ?? ""
        let backCategoryName = selectedBackCategory?.code ?? ""
        apiRequestParams.subcategory = "\(frontCategoryName)-\(backCategoryName)".lowercased()
        apiRequestParams.sortBy = selectedSortBy.rawValue
        presentationMode.wrappedValue.dismiss()
    }
    
    private func resetFilters() {
        apiRequestParams.subcategory = nil
        apiRequestParams.sortBy = nil
        Logger.debug("Filters reset: all parameters cleared")
        presentationMode.wrappedValue.dismiss()
    }
}
