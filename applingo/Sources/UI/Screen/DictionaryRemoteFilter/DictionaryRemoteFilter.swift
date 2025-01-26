import SwiftUI

struct DictionaryRemoteFilter: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var style: DictionaryRemoteFilterStyle
    @StateObject private var locale = DictionaryRemoteFilterLocale()
    @StateObject private var categoryGetter = CategoryRemoteGetterViewModel()

    @Binding var apiRequestParams: ApiDictionaryQueryRequestModel
    @State private var selectedSortBy: ApiSortType = .date
    @State private var selectedFrontCategory: CategoryItem?
    @State private var selectedBackCategory: CategoryItem?
    @State private var isPressedTrailing = false

    init(
        apiRequestParams: Binding<ApiDictionaryQueryRequestModel>,
        style: DictionaryRemoteFilterStyle? = nil
    ) {
        self._apiRequestParams = apiRequestParams
        let initialStyle = style ?? .themed(ThemeManager.shared.currentThemeStyle)
        _style = StateObject(wrappedValue: initialStyle)

        if let sortBy = apiRequestParams.wrappedValue.sortBy {
            _selectedSortBy = State(initialValue: sortBy == "rating" ? .rating : .date)
        }
    }

    var body: some View {
        BaseScreen(
            screen: .dictionariesRemoteFilter,
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

        DictionaryRemoteFilterViewActions(
            locale: locale,
            onSave: saveFilters,
            onReset: resetFilters
        )
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
