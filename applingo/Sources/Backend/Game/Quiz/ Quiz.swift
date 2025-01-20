import SwiftUI

class Quiz: ObservableObject, AbstractGame {
    var theme: GameTheme { ThemeManager.shared.currentThemeStyle.quizTheme }
    var availableModes: [GameModeEnum] = [.practice, .survival, .timeAttack]
    var type: GameType = .quiz
    
    var minimumWordsRequired: Int = 12
    var isReadyToPlay: Bool { true }
    
    func start(mode: GameModeEnum) {}
    func end() {}
}
