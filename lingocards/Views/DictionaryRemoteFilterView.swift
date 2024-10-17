import SwiftUI

struct DictionaryRemoteFilterView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var languageManager: LanguageManager
    @StateObject private var viewModel = DictionaryRemoteFilterViewModel()
    @State private var selectedFrontCategory: CategoryItem? = nil
    @State private var selectedBackCategory: CategoryItem? = nil
    
    // Получаем доступ к apiRequestParams из родительского View
    @Binding var apiRequestParams: DictionaryQueryRequest

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text(languageManager.localizedString(for: "Dictionary")).font(.headline)) {
                        HStack {
                            // Picker "from"
                            CompCategoryPickerView(
                                selectedCategory: $selectedFrontCategory,
                                categories: viewModel.frontCategories,
                                title: languageManager.localizedString(for: "from")
                            )
                            .environmentObject(languageManager)
                            .frame(maxWidth: .infinity)

                            Image(systemName: "arrow.left.and.right.circle.fill")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.blue)
                                .padding(.horizontal, 8)

                            // Picker "to"
                            CompCategoryPickerView(
                                selectedCategory: $selectedBackCategory,
                                categories: viewModel.backCategories,
                                title: languageManager.localizedString(for: "to")
                            )
                            .environmentObject(languageManager)
                            .frame(maxWidth: .infinity)
                        }
                    }
                }

                Spacer()

                HStack(spacing: 20) {
                    Button(action: {
                        // Конкатенируем front и back категории и присваиваем в apiRequestParams
                        let frontCategoryName = selectedFrontCategory?.name ?? ""
                        let backCategoryName = selectedBackCategory?.name ?? ""
                        apiRequestParams.categorySub = "\(frontCategoryName)-\(backCategoryName)"

                        Logger.debug("Filters saved: \(apiRequestParams.categorySub ?? "")")
                        presentationMode.wrappedValue.dismiss() // Закрываем окно
                    }) {
                        Text(languageManager.localizedString(for: "Save").capitalizedFirstLetter)
                            .font(.title2)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }

                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text(languageManager.localizedString(for: "Close").capitalizedFirstLetter)
                            .font(.title2)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
            }
            .navigationTitle(languageManager.localizedString(for: "Filter").capitalizedFirstLetter)
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                viewModel.getCategories()

                // Устанавливаем начальные значения для Picker
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
