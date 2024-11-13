import SwiftUI

struct InnerShadowBorderModifier: ViewModifier {
    let color: Color
    let isActive: Bool
    
    private let shadowRadius: CGFloat = 4
    private let borderWidth: CGFloat = 2
    private let cornerRadius: CGFloat = 20
    
    func body(content: Content) -> some View {
        content.overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(color, lineWidth: borderWidth)
                .blur(radius: shadowRadius)
                .opacity(isActive ? 0.8 : 0)
        )
        .animation(.easeInOut(duration: 0.3), value: isActive)
    }
}
