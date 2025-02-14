import SwiftUI

final class GameState: ObservableObject {
    @Published var currentMode: GameModeType?
    @Published var survivalState: SurvivalState?
    @Published var timeState: TimeState?
    
    struct SurvivalState {
        var lives: Int
    }
    
    struct TimeState {
        var timeLeft: TimeInterval
    }
}
