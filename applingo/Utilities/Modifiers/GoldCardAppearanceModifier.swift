import SwiftUI

struct GoldCardAppearanceModifier: ViewModifier {
    @State private var scale: CGFloat = 0.8
    @State private var rotation: Double = -180
    @State private var opacity: Double = 0
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(scale)
            .rotationEffect(.degrees(rotation))
            .opacity(opacity)
            .onAppear {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    scale = 1
                    rotation = 0
                    opacity = 1
                }
            }
    }
}
