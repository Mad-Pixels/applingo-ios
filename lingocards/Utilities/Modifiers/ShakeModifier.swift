import SwiftUI

struct ShakeModifier: ViewModifier {
    let duration: Double
    let isShaking: Bool
    
    func body(content: Content) -> some View {
        content
            .modifier(ShakeEffect(
                animatableData: isShaking ? 1 : 0,
                shakesPerUnit: 4,
                amount: 12
            ))
            .animation(
                .spring(response: 0.3, dampingFraction: 0.5)
                    .repeatCount(2, autoreverses: false),
                value: isShaking
            )
    }
}

private struct ShakeEffect: AnimatableModifier {
    var animatableData: CGFloat
    var shakesPerUnit: Int
    var amount: CGFloat
    
    func body(content: Content) -> some View {
        content.offset(x: amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)))
    }
}
