import SwiftUI

// MARK: - ItemCheckboxStyle
/// Defines the styling parameters for ItemCheckbox.
struct ItemCheckboxStyle {
    let activeColor: Color
    let inactiveColor: Color
    let borderColor: Color
    let size: CGFloat
    let borderWidth: CGFloat
}

extension ItemCheckboxStyle {
    /// Returns a themed style based on the provided AppTheme.
    static func themed(_ theme: AppTheme) -> ItemCheckboxStyle {
        ItemCheckboxStyle(
            activeColor: theme.accentPrimary,
            inactiveColor: .clear,
            borderColor: theme.textSecondary,
            size: 28,
            borderWidth: 2
        )
    }
}

// MARK: - CheckboxToggleStyle
/// A custom ToggleStyle that renders a checkbox.
struct CheckboxToggleStyle: ToggleStyle {
    @Environment(\.isEnabled) private var isEnabled
    let style: ItemCheckboxStyle

    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            // Draw the checkbox background and border
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

            // Draw the checkmark
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
