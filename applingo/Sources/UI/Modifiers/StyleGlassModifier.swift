import SwiftUI

/// A ViewModifier that applies a glass-like background effect using a blurred material (or a fallback color for older iOS versions).
///
/// The modifier uses a rounded rectangle with the specified corner radius and opacity as the background.
/// It also overlays a subtle white stroke to simulate a glass border effect.
///
/// - Parameters:
///   - cornerRadius: The corner radius for the rounded rectangle. Default is 16.
///   - opacity: The opacity of the background effect. Default is 0.9.
struct StyleGlassModifier: ViewModifier {
    let cornerRadius: CGFloat
    let opacity: CGFloat
    
    init(cornerRadius: CGFloat = 16, opacity: CGFloat = 0.9) {
        self.cornerRadius = cornerRadius
        self.opacity = opacity
    }
    
    func body(content: Content) -> some View {
        content
            .background {
                Group {
                    if #available(iOS 15.0, *) {
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .fill(.ultraThinMaterial)
                            .opacity(opacity)
                    } else {
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .fill(Color.gray.opacity(opacity/3))
                    }
                }
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(Color.white.opacity(0.1), lineWidth: 0.5)
                )
            }
    }
}
