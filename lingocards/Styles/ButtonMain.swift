import SwiftUI

struct ButtonMain: ButtonStyle {
    var backgroundColor: Color = .blue
    var textColor: Color = .white
    var cornerRadius: CGFloat = 10
    var width: CGFloat = 200
    var height: CGFloat = 50

    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(backgroundColor)
                .frame(width: width, height: height)
                .overlay(
                    configuration.label
                        .font(.title2)
                        .foregroundColor(textColor)
                )
        }
        .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
        .contentShape(Rectangle())
    }
}
