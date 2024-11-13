import SwiftUI

struct InnerShadowBorderModifier: ViewModifier {
    let isActive: Bool
    let color: Color
    
    func body(content: Content) -> some View {
        content.overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(color, lineWidth: 2)
                .blur(radius: 4)
                .opacity(isActive ? 0.5 : 0)
        )
    }
}
