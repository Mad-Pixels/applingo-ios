import SwiftUI

struct DictionaryRemoteFilterView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var languageManager: LanguageManager
    @StateObject private var viewModel = DictionaryRemoteFilterViewModel()
    @State private var selectedFrontCategory: CategoryItem? = nil
    @State private var selectedBackCategory: CategoryItem? = nil

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text(languageManager.localizedString(for: "Dictionary")).font(.headline)) {
                        HStack {
                            CompCategoryPickerView(
                                selectedCategory: $selectedFrontCategory,
                                categories: viewModel.frontCategories
                            )
                            .environmentObject(languageManager)
                            .frame(maxWidth: .infinity)

                            CompCategoryPickerView(
                                selectedCategory: $selectedBackCategory,
                                categories: viewModel.backCategories
                            )
                            .environmentObject(languageManager)
                            .frame(maxWidth: .infinity)
                        }
                    }
                }

                Spacer()

                HStack(spacing: 20) {
                    Button(action: {
                        Logger.debug("Filters saved")
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
            }
        }
    }
}
