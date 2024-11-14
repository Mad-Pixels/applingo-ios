import SwiftUI

class GameSpecialService: ObservableObject {
    private var specials: [GameSpecialProtocol]
    
    init(specials: [GameSpecialProtocol] = []) {
        self.specials = specials
    }
    
    func withSpecial(_ special: GameSpecialProtocol) -> GameSpecialService {
        GameSpecialService(specials: specials + [special])
    }
    
    func withSpecials(_ newSpecials: [GameSpecialProtocol]) -> GameSpecialService {
        GameSpecialService(specials: specials + newSpecials)
    }
    
    func isSpecial(_ item: WordItemModel) -> Bool {
        specials.contains { $0.isSpecial(item) }
    }
    
    func getActiveSpecial() -> (any GameSpecialScoringProtocol)? {
        specials.first as? any GameSpecialScoringProtocol
    }
    
    func getModifiers() -> [AnyViewModifier] {
        specials.flatMap { $0.modifiers() }
    }
}

private struct GameSpecialServiceKey: EnvironmentKey {
    static let defaultValue = GameSpecialService()
}

extension EnvironmentValues {
    var specialService: GameSpecialService {
        get { self[GameSpecialServiceKey.self] }
        set { self[GameSpecialServiceKey.self] = newValue }
    }
}

extension View {
    func withSpecial(_ special: GameSpecialProtocol) -> some View {
        environment(\.specialService, GameSpecialService().withSpecial(special))
    }
    
    func applySpecialEffects(_ modifiers: [AnyViewModifier]) -> some View {
        modifiers.reduce(AnyView(self)) { currentView, modifier in
            AnyView(currentView.modifier(modifier))
        }
    }
}

struct SpecialGoldCardConfig: GameSpecialConfigProtocol {
    let weightThreshold: Int
    let chance: Double
    let scoreMultiplier: Double
    
    static let standard = SpecialGoldCardConfig(
        weightThreshold: 1000,
        chance: 0.4,
        scoreMultiplier: 2.5
    )
}

final class SpecialGoldCard: GameSpecialProtocol, GameSpecialScoringProtocol {
    let config: GameSpecialConfigProtocol
    @Binding private var showSuccessEffect: Bool
    
    init(
        config: SpecialGoldCardConfig = .standard,
        showSuccessEffect: Binding<Bool>
    ) {
        self.config = config
        self._showSuccessEffect = showSuccessEffect
    }
    
    func isSpecial(_ item: WordItemModel) -> Bool {
        guard item.weight <= config.weightThreshold else { return false }
        return Double.random(in: 0...1) < config.chance
    }
    
    func modifiers() -> [AnyViewModifier] {
        [
            AnyViewModifier(GoldCardModifier(isActive: true)),
            AnyViewModifier(GoldCardAppearanceModifier()),
            AnyViewModifier(GoldCardSuccessEffectModifier(isActive: $showSuccessEffect))
        ]
    }
    
    func modifyScoreForCorrectAnswer(_ score: Int) -> Int {
        Int(Double(score) * config.scoreMultiplier)
    }
    
    func modifyScoreForWrongAnswer(_ score: Int) -> Int {
        score * 2
    }
}
