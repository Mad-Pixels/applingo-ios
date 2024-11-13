import SwiftUI

struct SpecialGoldCardConfig: GameSpecialConfig {
    let weightThreshold: Int = 400
    let chance: Double = 0.1
    let scoreMultiplier: Double = 2.5
}

struct SpecialGoldCardModifiers {
    let glow: GoldCardModifier
    let appearance: GoldCardAppearanceModifier
    let success: GoldCardSuccessEffectModifier
}

final class SpecialGoldCard: GameSpecial {
    private let config: SpecialGoldCardConfig
    @Binding private var showSuccessEffect: Bool
    
    init(config: SpecialGoldCardConfig = SpecialGoldCardConfig(), showSuccessEffect: Binding<Bool>) {
        self.config = config
        self._showSuccessEffect = showSuccessEffect
    }
    
    func isSpecial(_ item: WordItemModel) -> Bool {
        guard item.weight <= config.weightThreshold else { return false }
        return Double.random(in: 0...1) < config.chance
    }
    
    func calculateBonus(baseScore: Int) -> Int {
        Int(Double(baseScore) * config.scoreMultiplier)
    }
    
    func modifiers() -> [AnyViewModifier] {
        [
            AnyViewModifier(GoldCardModifier()),
            AnyViewModifier(GoldCardAppearanceModifier()),
            AnyViewModifier(GoldCardSuccessEffectModifier(isActive: $showSuccessEffect))
        ]
    }
}


struct AnyViewModifier: ViewModifier {
    private let modify: (AnyView) -> AnyView
    
    init<M: ViewModifier>(_ modifier: M) {
        self.modify = { view in
            AnyView(view.modifier(modifier))
        }
    }
    
    func body(content: Content) -> some View {
        modify(AnyView(content))
    }
}

extension View {
    func applySpecialEffects(_ modifiers: [AnyViewModifier]) -> some View {
        modifiers.reduce(AnyView(self)) { currentView, modifier in
            AnyView(currentView.modifier(modifier))
        }
    }
}
