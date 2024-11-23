import SwiftUI

struct GlassBackgroundModifier: ViewModifier {
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
