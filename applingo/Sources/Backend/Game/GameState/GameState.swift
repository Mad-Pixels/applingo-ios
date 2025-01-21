import SwiftUI

class GameState: ObservableObject {
    @Published var currentMode: GameModeType?
    @Published var survivalState: SurvivalState?
    @Published var timeState: TimeState?
    let stats: AbstractGameStats
    
    struct SurvivalState {
        var lives: Int
    }
    
    struct TimeState {
        var timeLeft: TimeInterval
    }
    
    init(stats: AbstractGameStats) {
        self.stats = stats
    }
}
