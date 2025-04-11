import SwiftUI

struct ItemPicker<Item: Hashable, Content: View>: View {
    @Binding var selectedValue: Item

    let items: [Item]
    let style: ItemPickerStyle
    let content: (Item) -> Content
    let onChange: ((Item) -> Void)?

    @State private var viewId = UUID()

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
        .onChange(of: items) { _ in
            viewId = UUID()
        }
        .onChange(of: selectedValue) { newValue in
            if !items.contains(newValue), let first = items.first {
                selectedValue = first
            }
        }
    }

    @ViewBuilder
    private var pickerContent: some View {
        if !items.isEmpty, items.contains(selectedValue) {
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
            .modifier(StylePickerModifier(style: style))
            .id(viewId)
        } else {
            EmptyView()
        }
    }
}
