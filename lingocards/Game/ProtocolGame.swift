import SwiftUI

protocol GameViewProtocol: View {
    var isPresented: Binding<Bool> { get }
}

protocol GameResultProtocol {
    var word: WordItemModel { get }
    var isCorrect: Bool { get }
    var responseTime: TimeInterval { get }
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

enum GameMode {
    case practice
    case survival
    case timeAttack
}
