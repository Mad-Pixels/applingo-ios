import SwiftUI

struct CompCategoryPickerView: View {
    @EnvironmentObject var languageManager: LanguageManager
    @Binding var selectedCategory: CategoryItem?
    var categories: [CategoryItem]

    var body: some View {
        Section {
            Picker(languageManager.localizedString(for: "Select Category"), selection: $selectedCategory) {
                ForEach(categories, id: \.name) { category in
                    Text(category.name)
                        .tag(category as CategoryItem?)
                }
            }
            .pickerStyle(WheelPickerStyle())
        }
    }
}
