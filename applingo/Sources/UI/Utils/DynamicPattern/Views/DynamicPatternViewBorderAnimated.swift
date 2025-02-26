import SwiftUI

/// A view that renders an animated dynamic pattern as a border.
/// It applies an animated dynamic pattern in the background of a transparent stroke border,
/// then masks the result with a rounded rectangle to ensure the pattern only appears along the border.
///
/// - Parameters:
///   - model: The model that defines the dynamic pattern.
///   - size: The size of the pattern.
///   - cornerRadius: The corner radius for the border's rounded rectangle.
///   - minScale: The minimum scale factor for the animation.
///   - animationDuration: The duration of one animation cycle.
///   - borderWidth: The width of the border.
struct DynamicPatternViewBorderAnimated: View {
    let model: DynamicPatternModel
    let size: CGSize
    let cornerRadius: CGFloat
    let minScale: CGFloat
    let animationDuration: Double
    let borderWidth: CGFloat
    
    @State private var isAnimating = false
    
    var body: some View {
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
            .onAppear {
                isAnimating = true
            }
    }
}
