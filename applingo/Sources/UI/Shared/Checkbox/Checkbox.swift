import SwiftUI

struct Checkbox: View {
    @Binding var isChecked: Bool
    let style: CheckboxStyle
    let onChange: ((Bool) -> Void)?
    
    init(
        isChecked: Binding<Bool>,
        style: CheckboxStyle = .themed(ThemeManager.shared.currentThemeStyle),
        onChange: ((Bool) -> Void)? = nil
    ) {
        self._isChecked = isChecked
        self.style = style
        self.onChange = onChange
    }
    
    var body: some View {
        Toggle(isOn: Binding(
            get: { isChecked },
            set: { newValue in
                isChecked = newValue
                onChange?(newValue)
            }
        )) {
            EmptyView()
        }
        .toggleStyle(CheckboxToggleStyle(style: style))
    }
}
