import SwiftUI

/// A ViewModifier that applies an animated dynamic background pattern to any view.
/// The pattern scales between a minimum scale and full size (1.0) while applying the specified opacity,
/// and it is masked with a rounded rectangle.
struct AnimatedBackgroundModifier: ViewModifier {
    let model: DynamicPatternModel
    let size: CGSize
    let cornerRadius: CGFloat
    let minScale: CGFloat
    let opacity: CGFloat
    let animationDuration: Double

    @State private var isAnimating: Bool = false

    func body(content: Content) -> some View {
        content
            .overlay(
                DynamicPattern(model: model, size: size)
                    .frame(width: size.width, height: size.height)
                    .opacity(opacity)
                    .scaleEffect(isAnimating ? 1 : minScale)
                    .animation(
                        .easeInOut(duration: animationDuration)
                            .repeatForever(autoreverses: true),
                        value: isAnimating
                    )
                    .mask(
                        RoundedRectangle(cornerRadius: cornerRadius)
                    )
                    .onAppear {
                        isAnimating = true
                    }
            )
    }
}
