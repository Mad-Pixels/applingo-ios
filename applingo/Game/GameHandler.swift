import SwiftUI
import Combine

final class GameHandler: ObservableObject {
    @Published private(set) var stats: GameStatsModel
    @Published private(set) var gameMode: GameModeEnum
    @Published private(set) var isGameActive: Bool = false
    
    private let scoreCalculator: GameScoreCalculator
    private var specialService: GameSpecialService
    private var timer: Timer?
    private var cancellables = Set<AnyCancellable>()
    private var onGameEnd: (() -> Void)?
    
    var onScoreChange: ((Int, ScoreAnimationReason) -> Void)?
    
    init(
        mode: GameModeEnum = .practice,
        stats: GameStatsModel = GameStatsModel(),
        scoreCalculator: GameScoreCalculator = GameScoreCalculator(),
        specialService: GameSpecialService = GameSpecialService(),
        onGameEnd: (() -> Void)? = nil
    ) {
        self.gameMode = mode
        self.stats = stats
        self.scoreCalculator = scoreCalculator
        self.specialService = specialService
        self.onGameEnd = onGameEnd
        
        setupSubscriptions()
    }
    
    func updateSpecialService(_ newService: GameSpecialService) {
        specialService = newService
    }
    
    func getSpecialsCount() -> Int {
        specialService.getSpecialsCount()
    }
    
    func startGame(mode: GameModeEnum) {
        stats.reset()
        gameMode = mode
        isGameActive = true
        
        switch mode {
        case .timeAttack:
            startTimer()
        case .survival:
            stats.resetLives(to: 3)
        case .practice:
            break
        }
    }
    
    func endGame() {
        stopTimer()
        isGameActive = false
        onGameEnd?()
    }
    
    func pauseGame() {
        stopTimer()
        isGameActive = false
    }
    
    func resumeGame() {
        if gameMode == .timeAttack {
            startTimer()
        }
        isGameActive = true
    }
    
    func setGameMode(_ mode: GameModeEnum) {
        gameMode = mode
    }
    
    func handleResult(_ result: GameResultProtocol) {
        guard isGameActive else { return }
        
        let activeSpecial = specialService.getActiveSpecial()
        let scoreResult = scoreCalculator.calculateScore(
            result: result,
            streak: stats.streak,
            special: activeSpecial
        )
        
        stats.update(with: result, scoreResult: scoreResult)
        checkGameEndConditions()
        onScoreChange?(scoreResult.total, scoreResult.reason)
    }
    
    func calculateWordWeight(success: Int, fail: Int) -> Int {
        guard success + fail > 0 else { return 500 }
        
        let successRate = Double(success) / Double(success + fail)
        let weight = Int(successRate * 1000)
        return min(max(weight, 0), 1000)
    }
    
    private func setupSubscriptions() {
        stats.objectWillChange
            .sink { [weak self] _ in
                self?.checkGameEndConditions()
            }
            .store(in: &cancellables)
    }
    
    private func startTimer() {
        stopTimer()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            if self.stats.timeRemaining > 0 {
                self.stats.decrementTime()
            } else {
                self.endGame()
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func checkGameEndConditions() {
        guard isGameActive else { return }
        
        switch gameMode {
        case .survival:
            if stats.lives <= 0 {
                endGame()
            }
        case .timeAttack:
            if stats.timeRemaining <= 0 {
                endGame()
            }
        case .practice:
            break
        }
    }
    
    deinit {
        stopTimer()
        cancellables.removeAll()
    }
}

extension GameHandler {
    var isTimeLimited: Bool {
        gameMode == .timeAttack
    }
    
    var hasLives: Bool {
        gameMode == .survival
    }
}

extension GameHandler {
    enum State {
        case notStarted
        case active
        case paused
        case finished
        
        var isActive: Bool {
            self == .active
        }
    }
    
    var gameState: State {
        if !isGameActive {
            return stats.isGameOver ? .finished : .notStarted
        }
        return timer == nil ? .paused : .active
    }
}
