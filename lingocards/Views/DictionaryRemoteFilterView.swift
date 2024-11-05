import SwiftUI

struct DictionaryRemoteFilterView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject private var categoryGetter: CategoryRemoteGetterViewModel
    @State private var selectedFrontCategory: CategoryItemModel? = nil
    @State private var selectedBackCategory: CategoryItemModel? = nil
    
    @Binding var apiRequestParams: DictionaryQueryRequest

    init(apiRequestParams: Binding<DictionaryQueryRequest>) {
        self._apiRequestParams = apiRequestParams
        _categoryGetter = StateObject(wrappedValue: CategoryRemoteGetterViewModel())
    }

    var body: some View {
        let theme = ThemeManager.shared.currentThemeStyle

        NavigationView {
            ZStack {
                theme.backgroundViewColor.edgesIgnoringSafeArea(.all)

                VStack {
                    Form {
                        Section(header: Text(LanguageManager.shared.localizedString(for: "Dictionary")).font(.headline).foregroundColor(theme.baseTextColor)) {
                            HStack {
                                CompPickerView(
                                    selectedValue: $selectedFrontCategory,
                                    items: categoryGetter.frontCategories,
                                    title: ""
                                ) { category in
                                    Text(category!.name)
                                }
                                .frame(maxWidth: .infinity)
                                
                                Image(systemName: "arrow.left.and.right.circle.fill")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .padding(.horizontal, 8)
                                    .modifier(MainIconStyle())
                                
                                CompPickerView(
                                    selectedValue: $selectedBackCategory,
                                    items: categoryGetter.backCategories,
                                    title: ""
                                ) { category in
                                    Text(category!.name)
                                }
                                .frame(maxWidth: .infinity)
                            }
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

                                Logger.debug("Filters saved: \(apiRequestParams.subcategory ?? "")")
                                presentationMode.wrappedValue.dismiss()
                            }
                        )

                        CompButtonCancelView(
                            title: LanguageManager.shared.localizedString(for: "Reset").capitalizedFirstLetter,
                            action: {
                                apiRequestParams.subcategory = nil
                                Logger.debug("Filters reset: categorySub set to an empty string")
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
                if FrameManager.shared.isActive(frame: .dictionaryRemoteFilter) {
                    categoryGetter.setFrame(.dictionaryRemoteFilter)
                }
                
                categoryGetter.get()
                if let firstFrontCategory = categoryGetter.frontCategories.first {
                    selectedFrontCategory = firstFrontCategory
                }
                if let firstBackCategory = categoryGetter.backCategories.first {
                    selectedBackCategory = firstBackCategory
                }
            }
        }
    }
}
