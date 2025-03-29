import SwiftUI

struct ItemCheckbox: View {
    @Binding var isChecked: Bool
    
    let style: ItemCheckboxStyle
    let onChange: ((Bool) -> Void)?
    let disabled: Bool

    /// Initializes the ItemCheckbox.
    /// - Parameters:
    ///   - isChecked: Binding to the checkbox state.
    ///   - disabled: Flag to disable the checkbox. Defaults to false.
    ///   - onChange: Closure called when the checkbox state changes.
    ///   - style: The style for the checkbox. Defaults to themed style using the current theme.
    init(
        isChecked: Binding<Bool>,
        disabled: Bool = false,
        onChange: ((Bool) -> Void)? = nil,
        style: ItemCheckboxStyle = .themed(ThemeManager.shared.currentThemeStyle)
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
        .toggleStyle(CheckboxToggleStyle(style: style))
        .disabled(disabled)
        .opacity(disabled ? 0.5 : 1.0)
    }
}
