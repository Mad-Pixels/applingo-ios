import SwiftUI

/// A view modifier that applies an animated dynamic pattern border to any view.
/// The modifier overlays an animated dynamic pattern on top of a transparent stroke border,
/// then masks the result with a rounded rectangle so that the pattern appears only along the border.
struct AnimatedBorderModifier: ViewModifier {
    let model: DynamicPatternModel
    let size: CGSize
    let cornerRadius: CGFloat
    let minScale: CGFloat
    let animationDuration: Double
    let borderWidth: CGFloat
    
    @State private var isAnimating: Bool = false
    
    func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .strokeBorder(Color.clear, lineWidth: borderWidth)
                    .background(
                        DynamicPattern(model: model, size: size)
                            .scaleEffect(isAnimating ? 1 : minScale)
                            .animation(
                                .easeInOut(duration: animationDuration)
                                    .repeatForever(autoreverses: true),
                                value: isAnimating
                            )
                    )
                    .mask(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .strokeBorder(style: StrokeStyle(lineWidth: borderWidth))
                    )
            )
            .onAppear {
                isAnimating = true
            }
    }
}
