import SwiftUI

struct ButtonFloatingSingle: View {
    let icon: String
    let action: () -> Void
    let style: ButtonFloatingStyle
    let disabled: Bool
    let left: Bool

    /// Initializes the ButtonFloatingSingle view.
    /// - Parameters:
    ///   - icon: SF Symbol name for the button icon.
    ///   - action: Action closure triggered when tapped.
    ///   - style: The style for the floating button. Defaults to themed style.
    ///   - disabled: Whether the button is disabled. Defaults to false.
    ///   - left: Whether the button should be aligned to the left side. Defaults to false (right side).
    init(
        icon: String,
        action: @escaping () -> Void,
        style: ButtonFloatingStyle = .themed(ThemeManager.shared.currentThemeStyle),
        disabled: Bool = false,
        left: Bool = false
    ) {
        self.icon = icon
        self.action = action
        self.style = style
        self.disabled = disabled
        self.left = left
    }

    var body: some View {
        ZStack {
            Button(action: action) {
                Image(systemName: icon)
                    .foregroundColor(.white.opacity(disabled ? 0.4 : 1))
                    .font(.system(size: 24, weight: .bold))
                    .frame(width: style.mainButtonSize.width, height: style.mainButtonSize.height)
                    .background(
                        ZStack {
                            Circle()
                                .fill(style.mainButtonColor)
                                .opacity(disabled ? 0.5 : 1)

                            Circle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: disabled
                                            ? [style.disabledButtonColor.opacity(0.6), style.disabledButtonColor]
                                            : [style.mainButtonColor.opacity(0.8), style.mainButtonColor]
                                        ),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )

                            Circle()
                                .stroke(Color.white.opacity(0.3), lineWidth: 1.5)
                                .padding(1)
                        }
                    )
                    .overlay(
                        Circle()
                            .stroke(
                                LinearGradient(
                                    gradient: Gradient(colors: [.white.opacity(0.3), .clear]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 2
                            )
                            .padding(2)
                    )
                    .shadow(color: style.shadowColor, radius: style.shadowRadius)
            }
            .disabled(disabled)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: left ? .bottomLeading : .bottomTrailing)
            .buttonStyle(ScaleButtonStyle())
            .padding(left ? .leading : .trailing, 16)
            .padding(.bottom, 18)
        }
    }
}
