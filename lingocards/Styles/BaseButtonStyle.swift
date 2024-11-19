import SwiftUI

struct BaseButtonStyle: ButtonStyle {
    let backgroundColor: Color
    let textColor: Color

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(configuration.isPressed ? textColor.opacity(0.8) : textColor)
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(backgroundColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(
                                configuration.isPressed ? textColor.opacity(0.2) : .clear,
                                lineWidth: 1
                            )
                    )
            )
            .shadow(color: configuration.isPressed ? .clear : Color.black.opacity(0.1), radius: 10, x: 0, y: 4)
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.spring(response: 0.25, dampingFraction: 0.7, blendDuration: 0), value: configuration.isPressed)
    }
}
