import SwiftUI

protocol AbstractGame {
    associatedtype ValidationAnswer
    
    var validation: any AbstractGameValidation { get }
    var stats: any AbstractGameStats { get }
    
    var availableModes: [GameModeType] { get }
    var scoring: AbstractGameScoring { get }
    var theme: GameTheme { get }
    var state: GameState { get }
    var type: GameType { get }
    
    var isReadyToPlay: Bool { get }
    
    func updateStats(correct: Bool, responseTime: TimeInterval, isSpecialCard: Bool)
    func validateAnswer(_ answer: ValidationAnswer) -> GameValidationResult
    func getModeModel(_ type: GameModeType) -> GameModeModel
    func start(mode: GameModeType)
    func end()
    
    @ViewBuilder
    func makeView() -> AnyView
}
