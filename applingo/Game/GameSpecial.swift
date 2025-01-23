import SwiftUI

class GameSpecialService: ObservableObject {
    private var specials: [GameSpecialProtocol]
    
    init(specials: [GameSpecialProtocol] = []) {
        self.specials = specials
    }
    
    func getSpecialsCount() -> Int {
        return specials.count
    }
    
    func withSpecial(_ special: GameSpecialProtocol) -> GameSpecialService {
        let newService = GameSpecialService(specials: specials + [special])
        return newService
    }
    
    func withSpecials(_ newSpecials: [GameSpecialProtocol]) -> GameSpecialService {
        GameSpecialService(specials: specials + newSpecials)
    }
    
    func isSpecial(_ item: DatabaseModelWord) -> Bool {
        let isSpecial = specials.contains { $0.isSpecial(item) }
        return isSpecial
    }
    
    func getActiveSpecial() -> (any GameSpecialScoringProtocol)? {
        specials.first as? any GameSpecialScoringProtocol
    }
    
    func getModifiers() -> [AnyViewModifier] {
        let allModifiers = specials.flatMap { special in
            return special.modifiers()
        }
        return allModifiers
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

struct SpecialGoldCardConfig: GameSpecialConfigProtocol {
    let weightThreshold: Int
    let chance: Double
    let scoreMultiplier: Double
    
    static let standard = SpecialGoldCardConfig(
        weightThreshold: 450,
        chance: 0.35,
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
    
    func isSpecial(_ item: DatabaseModelWord) -> Bool {
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
