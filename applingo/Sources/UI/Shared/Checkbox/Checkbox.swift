import SwiftUI

struct Checkbox: View {
    @Binding var isChecked: Bool
    let style: CheckboxStyle
    let onChange: ((Bool) -> Void)?
    let disabled: Bool

    init(
        isChecked: Binding<Bool>,
        disabled: Bool = false,
        onChange: ((Bool) -> Void)? = nil,
        style: CheckboxStyle = .themed(ThemeManager.shared.currentThemeStyle)
    ) {
        self.style = style
        self.onChange = onChange
        self.disabled = disabled
        self._isChecked = isChecked
    }
    
    var body: some View {
        Toggle(isOn: Binding(
            get: { isChecked },
            set: { newValue in
                if !disabled {
                    isChecked = newValue
                    onChange?(newValue)
                }
            }
        )) {
            EmptyView()
        }
        .toggleStyle(CheckboxToggleStyle(style: style, disabled: disabled))
        .disabled(disabled)
        .opacity(disabled ? 0.5 : 1.0)
    }
}
