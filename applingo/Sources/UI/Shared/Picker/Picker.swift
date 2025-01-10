import SwiftUI

struct AppPicker<Item: Hashable, Content: View>: View {
    @Binding var selectedValue: Item
    let items: [Item]
    let title: String?
    let style: AppPickerStyle
    let content: (Item) -> Content
    let onChange: ((Item) -> Void)?
    
    init(
        selectedValue: Binding<Item>,
        items: [Item],
        title: String? = nil,
        style: AppPickerStyle = .themed(ThemeManager.shared.currentThemeStyle),
        onChange: ((Item) -> Void)? = nil,
        @ViewBuilder content: @escaping (Item) -> Content
    ) {
        self._selectedValue = selectedValue
        self.items = items
        self.title = title
        self.style = style
        self.onChange = onChange
        self.content = content
    }
    
    var body: some View {
        Group {
            if let title = title {
                Section(header: Text(title)
                    .foregroundColor(style.titleColor)) {
                    pickerContent
                }
            } else {
                pickerContent
            }
        }
        .background(style.backgroundColor)
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
        .modifier(PickerStyleModifier(style: style.type))
        .accentColor(style.accentColor)
    }
}

struct PickerStyleModifier: ViewModifier {
    let style: AppPickerStyle.PickerType
    
    func body(content: Content) -> some View {
        switch style {
        case .wheel:
            content.pickerStyle(WheelPickerStyle())
        case .segmented:
            content.pickerStyle(SegmentedPickerStyle())
        case .menu:
            content.pickerStyle(MenuPickerStyle())
        case .inline:
            content.pickerStyle(DefaultPickerStyle())
        }
    }
}
