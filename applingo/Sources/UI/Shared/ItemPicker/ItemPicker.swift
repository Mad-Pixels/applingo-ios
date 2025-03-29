import SwiftUI

struct ItemPicker<Item: Hashable, Content: View>: View {
    @Binding var selectedValue: Item
    
    let items: [Item]
    let style: ItemPickerStyle
    let content: (Item) -> Content
    let onChange: ((Item) -> Void)?
    
    /// Initializes the ItemPicker.
    /// - Parameters:
    ///   - selectedValue: Binding to the selected item.
    ///   - items: Array of selectable items.
    ///   - onChange: Closure called on selection change.
    ///   - content: A view builder to render each item.
    ///   - style: The style for the picker. Defaults to themed style using the current theme.
    init(
        selectedValue: Binding<Item>,
        items: [Item],
        onChange: ((Item) -> Void)? = nil,
        @ViewBuilder content: @escaping (Item) -> Content,
        style: ItemPickerStyle = .themed(ThemeManager.shared.currentThemeStyle)
    ) {
        self._selectedValue = selectedValue
        self.onChange = onChange
        self.content = content
        self.items = items
        self.style = style
    }
    
    var body: some View {
        VStack(spacing: style.spacing) {
            SectionBody {
                pickerContent
                    .padding(.horizontal, style.type == .wheel ? 0 : style.spacing)
            }
        }
    }
    
    @ViewBuilder
    private var pickerContent: some View {
        Picker(selection: Binding(
            get: { selectedValue },
            set: { newValue in
                selectedValue = newValue
                onChange?(newValue)
            }
        ), label: EmptyView()) {
            ForEach(items, id: \.self) { item in
                content(item)
                    .tag(item)
            }
        }
        .modifier(PickerStyleModifier(style: style))
    }
}
