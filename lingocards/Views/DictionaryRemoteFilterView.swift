import SwiftUI

struct DictionaryRemoteFilterView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var languageManager: LanguageManager
    @StateObject private var viewModel = DictionaryRemoteFilterViewModel() // Используем ViewModel
    @State private var selectedFrontCategory: CategoryItem? = nil
    @State private var selectedBackCategory: CategoryItem? = nil

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    // Picker для frontCategories
                    CompCategoryPickerView(
                        selectedCategory: $selectedFrontCategory,
                        categories: viewModel.frontCategories
                    )
                    .environmentObject(languageManager)
                    
                    // Picker для backCategories
                    CompCategoryPickerView(
                        selectedCategory: $selectedBackCategory,
                        categories: viewModel.backCategories
                    )
                    .environmentObject(languageManager)
                }

                Spacer()

                // Кнопка Close для закрытия
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text(languageManager.localizedString(for: "Close").capitalizedFirstLetter)
                        .font(.title2)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }
            .navigationTitle(languageManager.localizedString(for: "Filter").capitalizedFirstLetter)
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                // Загружаем категории при появлении
                viewModel.getCategories()
            }
        }
    }
}
