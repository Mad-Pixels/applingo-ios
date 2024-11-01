import SwiftUI

struct DictionaryRemoteFilterView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var languageManager: LanguageManager
    @EnvironmentObject var themeManager: ThemeManager
    
    @StateObject private var viewModel = DictionaryRemoteFilterViewModel()
   
    @State private var selectedFrontCategory: CategoryItem? = nil
    @State private var selectedBackCategory: CategoryItem? = nil
    
    @Binding var apiRequestParams: DictionaryQueryRequest

    var body: some View {
        let theme = themeManager.currentThemeStyle

        NavigationView {
            ZStack {
                theme.backgroundViewColor.edgesIgnoringSafeArea(.all)

                VStack {
                    Form {
                        Section(header: Text(languageManager.localizedString(for: "Dictionary")).font(.headline).foregroundColor(theme.baseTextColor)) {
                            HStack {
                                CompPickerView(
                                    selectedValue: $selectedFrontCategory,
                                    items: viewModel.frontCategories,
                                    title: "",
                                    theme: theme
                                ) { category in
                                    Text(category!.name)
                                }
                                .frame(maxWidth: .infinity)
                                
                                Image(systemName: "arrow.left.and.right.circle.fill")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .padding(.horizontal, 8)
                                    .modifier(MainIconStyle(theme: theme))
                                
                                CompPickerView(
                                    selectedValue: $selectedBackCategory,
                                    items: viewModel.backCategories,
                                    title: "",
                                    theme: theme
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
                            title: languageManager.localizedString(for: "Save").capitalizedFirstLetter,
                            action: {
                                let frontCategoryName = selectedFrontCategory?.name ?? ""
                                let backCategoryName = selectedBackCategory?.name ?? ""
                                apiRequestParams.categorySub = "\(frontCategoryName)-\(backCategoryName)".lowercased()

                                Logger.debug("Filters saved: \(apiRequestParams.categorySub ?? "")")
                                presentationMode.wrappedValue.dismiss()
                            },
                            theme: theme
                        )

                        CompButtonCancelView(
                            title: languageManager.localizedString(for: "Reset").capitalizedFirstLetter,
                            action: {
                                apiRequestParams.categorySub = nil
                                Logger.debug("Filters reset: categorySub set to an empty string")
                                presentationMode.wrappedValue.dismiss()
                            },
                            theme: theme
                        )
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                }
                .background(theme.detailsColor)
            }
            .navigationTitle(languageManager.localizedString(for: "Filter").capitalizedFirstLetter)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                trailing: Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text(languageManager.localizedString(for: "Close").capitalizedFirstLetter)
                        .foregroundColor(theme.accentColor)
                }
            )
            .onAppear {
                viewModel.getCategories()

                if let firstFrontCategory = viewModel.frontCategories.first {
                    selectedFrontCategory = firstFrontCategory
                }
                if let firstBackCategory = viewModel.backCategories.first {
                    selectedBackCategory = firstBackCategory
                }
            }
        }
    }
}
