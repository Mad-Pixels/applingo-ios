import SwiftUI

struct CompPickerView<Item: Hashable, Content: View>: View {
    @EnvironmentObject var languageManager: LanguageManager
    @Binding var selectedValue: Item
    var items: [Item]
    var title: String
    var theme: ThemeStyle
    var content: (Item) -> Content
    
    var body: some View {
        if title.isEmpty {
            Picker("", selection: $selectedValue) {
                ForEach(items, id: \.self) { item in
                    content(item)
                        .tag(item)
                }
            }
            .pickerStyle(WheelPickerStyle())
        } else {
            Section(header: Text(languageManager.localizedString(for: title))
                .modifier(HeaderBlockTextStyle(theme: theme))) {
                
                Picker(title, selection: $selectedValue) {
                    ForEach(items, id: \.self) { item in
                        content(item)
                            .tag(item)
                    }
                }
                .pickerStyle(WheelPickerStyle())
            }
        }
    }
}
