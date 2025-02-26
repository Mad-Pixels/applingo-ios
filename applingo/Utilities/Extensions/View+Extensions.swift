import SwiftUI

extension View {
    @ViewBuilder
    func `if`(_ condition: Bool, transform: (Self) -> some View) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
    
    func anyView() -> AnyView {
        AnyView(self)
    }
    
    func glassBackground(
        cornerRadius: CGFloat = 16,
        opacity: CGFloat = 0.85
    ) -> some View {
        let adjustedOpacity = ThemeManager.shared.currentTheme == .dark ? opacity : 0.98 // фиксированное значение для светлой темы
        return modifier(GlassBackgroundModifier(
            cornerRadius: cornerRadius,
            opacity: adjustedOpacity
        ))
    }
    
//    func gameCardStyle(_ style: GameCardStyle) -> some View {
//        modifier(style.makeBaseModifier())
//    }
//    
//    func gameCardSpecialEffects(
//        style: GameCardStyle,
//        isSpecial: Bool,
//        specialService: GameSpecialService
//    ) -> some View {
//        modifier(
//            style.makeSpecialEffectsModifier(
//                isSpecial: isSpecial,
//                specialService: specialService
//            )
//        )
//    }
    
//    func withVisualFeedback<F: GameFeedbackVisualProtocol>(_ feedback: F) -> some View {
//        modifier(feedback.modifier())
//    }
//    
//    func withHapticFeedback(_ feedback: GameFeedbackHapticProtocol) -> some View {
//        onAppear {
//            feedback.playHaptic()
//        }
//    }
//    
//    func withSpecial(_ special: GameSpecialProtocol) -> some View {
//        environment(\.specialService, GameSpecialService().withSpecial(special))
//    }
    
    func applySpecialEffects(_ modifiers: [AnyViewModifier]) -> some View {
        return modifiers.reduce(AnyView(self)) { currentView, modifier in
            return modifier.modify(currentView)
        }
    }
}
