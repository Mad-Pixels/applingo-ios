import SwiftUI

struct ShakeModifier: ViewModifier {
    let isShaking: Bool
    let duration: Double
    
    private let defaultAmount: CGFloat = 10
    private let defaultShakesPerUnit = 3
    
    func body(content: Content) -> some View {
        content
            .modifier(ShakeEffect(
                amount: defaultAmount,
                shakesPerUnit: defaultShakesPerUnit,
                animatableData: isShaking ? 1 : 0
            ))
            .animation(
                .spring(response: duration * 0.6, dampingFraction: 0.5)
                    .repeatCount(2, autoreverses: false),
                value: isShaking
            )
    }
}

private struct ShakeEffect: AnimatableModifier {
    var amount: CGFloat = 10
    var shakesPerUnit = 3
    var animatableData: CGFloat
    
    func body(content: Content) -> some View {
        content.offset(x: amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)))
    }
}
