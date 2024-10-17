import SwiftUI

struct CompCategoryPickerView: View {
    @EnvironmentObject var languageManager: LanguageManager
    @Binding var selectedCategory: CategoryItem?
    var categories: [CategoryItem]
    var title: String
    
    var body: some View {
        VStack(alignment: .center) {
            Picker(selection: $selectedCategory, label: Text(title)) {
                ForEach(categories, id: \.name) { category in
                    Text(category.name)
                        .tag(category as CategoryItem?)
                }
            }
            .pickerStyle(WheelPickerStyle())
        }
    }
}
