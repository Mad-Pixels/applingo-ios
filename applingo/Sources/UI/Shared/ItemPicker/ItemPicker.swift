import SwiftUI

// MARK: - ItemPicker View
/// A generic picker with custom content, header, and style.
struct ItemPicker<Item: Hashable, Content: View>: View {
    @Binding var selectedValue: Item
    let items: [Item]
    let title: String?
    let style: ItemPickerStyle
    let content: (Item) -> Content
    let onChange: ((Item) -> Void)?
    
    /// Initializes the item picker.
    /// - Parameters:
    ///   - selectedValue: Binding to the selected item.
    ///   - items: Array of selectable items.
    ///   - title: Optional header title.
    ///   - style: The style for the picker. Defaults to themed style using the current theme.
    ///   - onChange: Closure called on selection change.
    ///   - content: A view builder to render each item.
    init(
        selectedValue: Binding<Item>,
        items: [Item],
        title: String? = nil,
        style: ItemPickerStyle = .themed(ThemeManager.shared.currentThemeStyle),
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
        VStack(spacing: style.spacing) {
            if let title = title {
                // Use titled SectionHeader for the picker header
                SectionHeader(
                    title: title,
                    style: .titled(ThemeManager.shared.currentThemeStyle)
                )
            }
            
            SectionBody {
                pickerContent
                    .padding(.horizontal, style.type == .wheel ? 0 : style.spacing)
            }
        }
    }
    
    /// The picker content with custom modifier for picker style.
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

// MARK: - PickerStyleModifier
/// A view modifier to apply different picker styles based on configuration.
struct PickerStyleModifier: ViewModifier {
    let style: ItemPickerStyle
    
    func body(content: Content) -> some View {
        Group {
            switch style.type {
            case .wheel:
                content
                    .pickerStyle(WheelPickerStyle())
            case .segmented:
                content
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal, style.spacing)
            case .menu:
                content
                    .pickerStyle(MenuPickerStyle())
                    .padding(.horizontal, style.spacing)
            case .inline:
                content
                    .pickerStyle(DefaultPickerStyle())
                    .listRowBackground(style.backgroundColor)
            }
        }
        .accentColor(style.accentColor)
    }
}
