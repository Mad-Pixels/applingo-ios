import SwiftUI

struct FloatingButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .clipShape(Circle())
            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
            .scaleEffect(configuration.isPressed ? 1.1 : 1.0)
    }
}
