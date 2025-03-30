import SwiftUI

struct ItemListError: View {
    let error: Error
    let style: ItemListStyle
    
    var body: some View {
        DynamicText(
            model: DynamicTextModel(text: error.localizedDescription),
            style: .textMain(ThemeManager.shared.currentThemeStyle)
        )
        .foregroundColor(style.errorColor)
        .listRowBackground(Color.clear)
        .padding(style.padding)
    }
}
