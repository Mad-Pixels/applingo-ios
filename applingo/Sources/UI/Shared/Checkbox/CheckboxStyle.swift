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
            size: 28,
            borderWidth: 2
        )
    }
}

struct CheckboxToggleStyle: ToggleStyle {
    @Environment(\.isEnabled) private var isEnabled
    let style: CheckboxStyle

    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .stroke(
                    configuration.isOn ? style.activeColor : style.borderColor,
                    lineWidth: configuration.isOn ? 0 : style.borderWidth
                )
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(configuration.isOn ? style.activeColor : style.inactiveColor)
                )
                .frame(width: style.size, height: style.size)

            Image(systemName: "checkmark")
                .font(.system(size: style.size * 0.5, weight: .bold))
                .foregroundColor(.white)
                .opacity(configuration.isOn ? 1 : 0)
                .scaleEffect(configuration.isOn ? 1 : 0.5)
                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: configuration.isOn)
        }
        .opacity(isEnabled ? 1 : 0.5)
        .onTapGesture {
            configuration.isOn.toggle()
        }
    }
}
