import SwiftUI

class Quiz: ObservableObject, AbstractGame {
    var type: GameType = .quiz
    var minimumWordsRequired: Int = 12
    var availableModes: [GameModeEnum] = [.practice, .survival, .timeAttack]
    var isReadyToPlay: Bool { true }
    
    func start(mode: GameModeEnum) {}
    func end() {}
}
