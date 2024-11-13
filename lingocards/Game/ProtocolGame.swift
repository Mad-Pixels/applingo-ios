import SwiftUI

protocol GameViewProtocol: View {
    var isPresented: Binding<Bool> { get }
}

protocol GameResultProtocol {
    var word: WordItemModel { get }
    var isCorrect: Bool { get }
    var responseTime: TimeInterval { get }
    var isSpecial: Bool { get }
    var hintPenalty: Int { get }
}

protocol GameFeedbackProtocol {
    func trigger()
}

protocol GameFeedbackVisualProtocol: GameFeedbackProtocol {
    associatedtype ModifierType: ViewModifier
    func modifier() -> ModifierType
}

protocol GameFeedbackHapticProtocol: GameFeedbackProtocol {
    func playHaptic()
}

protocol GameSpecialConfig {
    var chance: Double { get }
    var scoreMultiplier: Double { get }
}

protocol GameSpecial {
    func isSpecial(_ item: WordItemModel) -> Bool
    func calculateBonus(baseScore: Int) -> Int
    func modifiers() -> [AnyViewModifier]
}

protocol GameSpecialEffect {
    func trigger()
}

enum GameMode {
    case practice
    case survival
    case timeAttack
}
