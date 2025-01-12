import SwiftUI

struct CheckboxStyle {
    let activeColor: Color
    let inactiveColor: Color
    let borderColor: Color
    let size: CGFloat
    let borderWidth: CGFloat
}

struct CheckboxToggleStyle: ToggleStyle {
    let style: CheckboxStyle
    let disabled: Bool

    func makeBody(configuration: Configuration) -> some View {
        Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
            .foregroundColor(disabled ? style.borderColor.opacity(0.5) : (configuration.isOn ? style.activeColor : style.borderColor))
            .font(.system(size: style.size))
            .onTapGesture {
                if !disabled {
                    configuration.isOn.toggle()
                }
            }
    }
}

extension CheckboxStyle {
    static func themed(_ theme: AppTheme) -> CheckboxStyle {
        CheckboxStyle(
            activeColor: theme.accentPrimary,
            inactiveColor: .clear,
            borderColor: theme.textSecondary,
            size: 24,
            borderWidth: 2
        )
    }
}
