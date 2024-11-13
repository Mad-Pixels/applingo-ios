import SwiftUI

struct SpecialGoldCardConfig: GameSpecialConfig {
    let weightThreshold: Int = 450
    let chance: Double = 0.4
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
            AnyViewModifier(GoldCardModifier(isActive: true)),
            AnyViewModifier(GoldCardAppearanceModifier()),
            AnyViewModifier(GoldCardSuccessEffectModifier(isActive: $showSuccessEffect))
        ]
    }
}

extension View {
    func applySpecialEffects(_ modifiers: [AnyViewModifier]) -> some View {
        modifiers.reduce(AnyView(self)) { currentView, modifier in
            AnyView(currentView.modifier(modifier))
        }
    }
}
