import SwiftUI

final class GameState: ObservableObject {
    @Published var currentMode: GameModeType?
    @Published var survivalState: SurvivalState?
    @Published var timeState: TimeState?
    let stats: any AbstractGameStats
    
    struct SurvivalState {
        var lives: Int
    }
    
    struct TimeState {
        var timeLeft: TimeInterval
    }
    
    init(stats: any AbstractGameStats) {
        self.stats = stats
    }
}
