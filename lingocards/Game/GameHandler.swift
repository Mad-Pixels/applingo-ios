import SwiftUI
import Combine

class GameHandler: ObservableObject {
    @Published var stats: GameStatsModel
    @Published var gameMode: GameMode = .practice
    @Published var isGameActive = false
    
    private var timer: Timer?
    private var cancellables = Set<AnyCancellable>()
    var onGameEnd: (() -> Void)?
    
    init(mode: GameMode = .practice, stats: GameStatsModel = GameStatsModel(), onGameEnd: (() -> Void)? = nil) {
        self.onGameEnd = onGameEnd
        self.gameMode = mode
        self.stats = stats
    }
    
    func startGame(mode: GameMode) {
        stats = GameStatsModel()
        isGameActive = true
        gameMode = mode
        
        switch mode {
        case .timeAttack:
            startTimer()
        case .survival:
            stats.lives = 3
        default:
            break
        }
    }
    
    func endGame() {
        timer?.invalidate()
        timer = nil
        isGameActive = false
        onGameEnd?()
    }
    
    func calculateWordWeight(success: Int, fail: Int) -> Int {
        guard success + fail > 0 else {
            return 500
        }
        let successRate = Double(success) / Double(success + fail)
        let weight = Int(successRate * 1000)
        let finalWeight = min(max(weight, 0), 1000)
        return finalWeight
    }
    
    func handleGameResult(_ result: GameResultProtocol) {
        stats.updateStats(
            isCorrect: result.isCorrect,
            responseTime: result.responseTime
        )
        checkGameEndConditions()
    }
    
    deinit {
        timer?.invalidate()
        cancellables.removeAll()
    }
    
    private func startTimer() {
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if self.stats.timeRemaining > 0 {
                self.stats.timeRemaining -= 1
            } else {
                self.endGame()
            }
        }
    }
    
    private func checkGameEndConditions() {
        switch gameMode {
        case .survival where stats.lives <= 0:
            endGame()
        case .timeAttack where stats.timeRemaining <= 0:
            endGame()
        default:
            break
        }
    }
}
