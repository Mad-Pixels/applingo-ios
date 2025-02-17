import SwiftUI

/// A view that renders an animated dynamic pattern.
/// The pattern scales between a minimum scale and 1.0 while applying the specified opacity,
/// and it is masked with a rounded rectangle.
///
/// Use this component to display a background or border pattern with animation.
///
/// - Parameters:
///   - model: The model that defines the dynamic pattern.
///   - size: The size of the pattern.
///   - cornerRadius: The corner radius used for masking the pattern.
///   - minScale: The minimum scale factor for the animation.
///   - opacity: The opacity applied to the pattern.
///   - animationDuration: The duration of one animation cycle.
struct DynamicPatternViewBackgroundAnimated: View {
    let model: DynamicPatternModel
    let size: CGSize
    let cornerRadius: CGFloat
    let minScale: CGFloat
    let opacity: CGFloat
    let animationDuration: Double
    
    @State private var isAnimating = false
    
    var body: some View {
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
    }
}
