import SwiftUI

protocol AbstractGame {
    associatedtype ValidationAnswer
    var validation: any AbstractGameValidation { get }
    
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
    func validateAnswer(_ answer: ValidationAnswer) -> GameValidationResult
    func updateStats(correct: Bool, responseTime: TimeInterval, isSpecialCard: Bool)
    func getModeModel(_ type: GameModeType) -> GameModeModel
    
    @ViewBuilder
    func makeView() -> AnyView
}
