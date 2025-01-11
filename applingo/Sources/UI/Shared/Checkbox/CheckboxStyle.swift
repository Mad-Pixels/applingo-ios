import SwiftUI

struct CheckboxStyle {
    let activeColor: Color
    let inactiveColor: Color
    let borderColor: Color
    let size: CGFloat
    let borderWidth: CGFloat
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

struct CheckboxToggleStyle: ToggleStyle {
    let style: CheckboxStyle
    
    func makeBody(configuration: Configuration) -> some View {
        Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
            .foregroundColor(configuration.isOn ? style.activeColor : style.borderColor)
            .font(.system(size: style.size))
            .onTapGesture {
                configuration.isOn.toggle()
            }
    }
}
