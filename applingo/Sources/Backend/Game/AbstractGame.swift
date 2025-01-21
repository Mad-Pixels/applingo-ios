import SwiftUI

protocol AbstractGame {
    var availableModes: [GameModeType] { get }
    var minimumWordsRequired: Int { get }
    var theme: GameTheme { get }
    var type: GameType { get }
    
    var scoring: AbstractGameScoring { get }
    var stats: AbstractGameStats { get }
    var state: GameState { get }
    
    var isReadyToPlay: Bool { get }
    
    func start(mode: GameModeType)
    func end()
    func handleAnswer(correct: Bool, responseTime: TimeInterval, isSpecialCard: Bool)
    
    @ViewBuilder
    func makeView() -> AnyView
}
