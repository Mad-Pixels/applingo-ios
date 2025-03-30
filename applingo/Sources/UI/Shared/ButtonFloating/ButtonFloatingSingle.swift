import SwiftUI

struct ButtonFloatingSingle: View {
    let icon: String
    let action: () -> Void
    let style: ButtonFloatingStyle
    
    /// Initializes the ButtonFloatingSingle view.
    /// - Parameters:
    ///   - icon: SF Symbol name for the button icon.
    ///   - action: Action closure triggered when tapped.
    ///   - style: The style for the floating button. Defaults to themed style.
    init(
        icon: String,
        action: @escaping () -> Void,
        style: ButtonFloatingStyle = .themed(ThemeManager.shared.currentThemeStyle)
    ) {
        self.icon = icon
        self.action = action
        self.style = style
    }

    var body: some View {
        ZStack {
            Button(action: action) {
                Image(systemName: icon)
                    .foregroundColor(.white)
                    .font(.system(size: 24, weight: .bold))
                    .frame(width: style.mainButtonSize.width, height: style.mainButtonSize.height)
                    .background(
                        ZStack {
                            Circle()
                                .fill(style.mainButtonColor)
                            
                            Circle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            style.mainButtonColor.opacity(0.8),
                                            style.mainButtonColor
                                        ]),
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
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
            .buttonStyle(ScaleButtonStyle())
            .padding(.trailing, 16)
            .padding(.bottom, 18)
        }
    }
}
