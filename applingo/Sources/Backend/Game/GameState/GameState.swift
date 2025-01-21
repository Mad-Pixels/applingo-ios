import SwiftUI

class GameState: ObservableObject {
    @Published var stats: AbstractGameStats
    @Published var currentLives: Int
    @Published var timeElapsed: TimeInterval
    @Published var isGameOver: Bool
    
    init(stats: AbstractGameStats, initialLives: Int = 0) {
        self.stats = stats
        self.currentLives = initialLives
        self.timeElapsed = 0
        self.isGameOver = false
    }
}
