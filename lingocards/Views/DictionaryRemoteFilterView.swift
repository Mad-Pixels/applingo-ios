import SwiftUI

struct DictionaryRemoteFilterView: View {
    @Environment(\.presentationMode) var presentationMode

    @StateObject private var categoryGetter: CategoryRemoteGetterViewModel
    @State private var selectedFrontCategory: CategoryItem? = nil
    @State private var selectedBackCategory: CategoryItem? = nil
    @State private var selectedSortBy: ApiDictionaryQueryRequestModel.SortBy = .date

    @Binding var apiRequestParams: ApiDictionaryQueryRequestModel
    
    @State private var errorMessage: String = ""
    @State private var isShowingAlert = false

    init(apiRequestParams: Binding<ApiDictionaryQueryRequestModel>) {
        self._apiRequestParams = apiRequestParams
        _categoryGetter = StateObject(wrappedValue: CategoryRemoteGetterViewModel())
        
        if let sortBy = apiRequestParams.wrappedValue.sortBy {
            _selectedSortBy = State(initialValue: sortBy == "rating" ? .rating : .date)
        }
    }

    var body: some View {
        let theme = ThemeManager.shared.currentThemeStyle

        NavigationView {
            ZStack {
                theme.backgroundViewColor.edgesIgnoringSafeArea(.all)

                VStack {
                    Form {
                        Section(header: Text(LanguageManager.shared.localizedString(
                            for: "Dictionary"
                        )).font(.headline).foregroundColor(theme.baseTextColor)) {
                            ZStack {
                                if !categoryGetter.isLoadingPage {
                                    HStack {
                                        CompPickerView(
                                            selectedValue: $selectedFrontCategory,
                                            items: categoryGetter.frontCategories,
                                            title: ""
                                        ) { category in
                                            Text(category?.name ?? "")
                                        }
                                        .frame(maxWidth: .infinity)

                                        ZStack {
                                            Capsule()
                                                .fill(ThemeManager.shared.currentThemeStyle.accentColor.opacity(0.1))
                                                .frame(width: 36, height: 24)
                                            
                                            Image(systemName: "arrow.left.and.right")
                                                .font(.system(size: 12, weight: .medium))
                                                .foregroundColor(ThemeManager.shared.currentThemeStyle.accentColor)
                                        }

                                        CompPickerView(
                                            selectedValue: $selectedBackCategory,
                                            items: categoryGetter.backCategories,
                                            title: ""
                                        ) { category in
                                            Text(category?.name ?? "")
                                        }
                                        .frame(maxWidth: .infinity)
                                    }
                                } else {
                                    VStack {
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle())
                                            .scaleEffect(1.5)
                                            .padding()
                                    }
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                }
                            }
                        }
                        
                        CompSelectView(
                            selectedValue: $selectedSortBy,
                            items: ApiDictionaryQueryRequestModel.SortBy.allCases,
                            title: LanguageManager.shared.localizedString(for: "SortBy"),
                            style: .segmented
                        ) { sortBy in
                            Text(sortBy.displayName)
                        }
                    }
                    Spacer()

                    HStack {
                        CompButtonActionView(
                            title: LanguageManager.shared.localizedString(for: "Save").capitalizedFirstLetter,
                            action: {
                                let frontCategoryName = selectedFrontCategory?.name ?? ""
                                let backCategoryName = selectedBackCategory?.name ?? ""
                                apiRequestParams.subcategory = "\(frontCategoryName)-\(backCategoryName)".lowercased()
                                apiRequestParams.sortBy = selectedSortBy.rawValue
                                
                                Logger.debug("Filters saved: subcategory: \(apiRequestParams.subcategory ?? ""), sortBy: \(apiRequestParams.sortBy ?? "")")
                                presentationMode.wrappedValue.dismiss()
                            }
                        )

                        CompButtonCancelView(
                            title: LanguageManager.shared.localizedString(for: "Reset").capitalizedFirstLetter,
                            action: {
                                apiRequestParams.subcategory = nil
                                apiRequestParams.sortBy = nil
                                Logger.debug("Filters reset: all parameters cleared")
                                presentationMode.wrappedValue.dismiss()
                            }
                        )
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                }
                .background(theme.detailsColor)
            }
            .navigationTitle(LanguageManager.shared.localizedString(for: "Filter").capitalizedFirstLetter)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                trailing: Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text(LanguageManager.shared.localizedString(for: "Close").capitalizedFirstLetter)
                        .foregroundColor(theme.accentColor)
                }
            )
            .onAppear {
                FrameManager.shared.setActiveFrame(.dictionaryRemoteFilter)
                categoryGetter.setFrame(.dictionaryRemoteFilter)
                categoryGetter.get { _ in }
            }
            .onDisappear() {
                categoryGetter.clear()
            }
            .onReceive(NotificationCenter.default.publisher(for: .errorVisibilityChanged)) { _ in
                if let error = ErrorManager.shared.currentError,
                   error.frame == .dictionaryRemoteFilter {
                    errorMessage = error.localizedMessage
                    isShowingAlert = true
                }
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
            .alert(isPresented: $isShowingAlert) {
                CompAlertView(
                    title: LanguageManager.shared.localizedString(for: "Error"),
                    message: errorMessage,
                    closeAction: {
                        ErrorManager.shared.clearError()
                    }
                )
            }
        }
    }
}
