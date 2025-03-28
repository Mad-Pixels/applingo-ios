import SwiftUI

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
