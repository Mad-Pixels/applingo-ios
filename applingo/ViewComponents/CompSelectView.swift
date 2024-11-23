import SwiftUI

struct CompSelectView<T: Hashable, Content: View>: View {
    @EnvironmentObject var languageManager: LanguageManager
    
    @Binding var selectedValue: T
    var items: [T]
    var title: String
    var displayValue: (T) -> Content
    var onChange: ((T) -> Void)?
    var style: SelectStyle
    
    enum SelectStyle {
        case segmented
        case picker
    }
    
    init(
        selectedValue: Binding<T>,
        items: [T],
        title: String,
        style: SelectStyle = .segmented,
        onChange: ((T) -> Void)? = nil,
        @ViewBuilder displayValue: @escaping (T) -> Content
    ) {
        self._selectedValue = selectedValue
        self.items = items
        self.title = title
        self.style = style
        self.onChange = onChange
        self.displayValue = displayValue
    }
    
    var body: some View {
        Section(header: Text(title)
            .modifier(HeaderBlockTextStyle())) {
            
            switch style {
            case .segmented:
                Picker("Select", selection: Binding(
                    get: { selectedValue },
                    set: { newValue in
                        selectedValue = newValue
                        onChange?(newValue)
                    }
                )) {
                    ForEach(items, id: \.self) { item in
                        displayValue(item)
                            .tag(item)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                
            case .picker:
                Picker("Select", selection: Binding(
                    get: { selectedValue },
                    set: { newValue in
                        selectedValue = newValue
                        onChange?(newValue)
                    }
                )) {
                    ForEach(items, id: \.self) { item in
                        displayValue(item)
                            .tag(item)
                    }
                }
                .pickerStyle(DefaultPickerStyle())
            }
        }
    }
}
