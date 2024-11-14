import Foundation
import Combine
import SwiftUI

final class GameActionViewModel: BaseDatabaseViewModel {
    @Published private(set) var stats: GameStatsModel
    @Published private(set) var gameMode: GameMode = .practice
    @Published private(set) var isGameActive = false
    
    private let gameHandler: GameHandler
    private let scoreCalculator: GameScoreCalculator
    private let repository: WordRepositoryProtocol
    
    private var cancellables = Set<AnyCancellable>()
    private var frame: AppFrameModel = .main
    private var specialService: GameSpecialService {
        didSet {
            gameHandler.updateSpecialService(specialService)
        }
    }
    var onScoreChange: ((Int, ScoreAnimationReason) -> Void)?
    
    init(repository: WordRepositoryProtocol) {
        self.repository = repository
        self.scoreCalculator = GameScoreCalculator()
        self.specialService = GameSpecialService()
        
        let initialStats = GameStatsModel()
        self.stats = initialStats
        self.gameHandler = GameHandler(
            stats: initialStats,
            scoreCalculator: scoreCalculator,
            specialService: specialService
        )
        super.init()
        setupBindings()
    }
    
    private func setupBindings() {
        print("🎮 GameActionViewModel: Setting up bindings")
        gameHandler.$stats
            .sink { [weak self] newStats in
                print("📊 Stats updated: score=\(newStats.score), streak=\(newStats.streak)")
                self?.stats = newStats
            }
            .store(in: &cancellables)
        
        gameHandler.$gameMode
            .sink { [weak self] newMode in
                print("🎲 Game mode changed to: \(newMode)")
                self?.gameMode = newMode
            }
            .store(in: &cancellables)
        
        gameHandler.$isGameActive
            .sink { [weak self] isActive in
                print("🎯 Game active state changed to: \(isActive)")
                self?.isGameActive = isActive
            }
            .store(in: &cancellables)
    }
    
    func setGameMode(_ mode: GameMode) {
        print("🎮 Setting game mode to: \(mode)")
        gameHandler.setGameMode(mode)
    }
    
    func startGame() {
        print("🎮 Starting game in mode: \(gameMode)")
        gameHandler.startGame(mode: gameMode)
    }
    
    func endGame() {
        print("🎮 Ending game")
        gameHandler.endGame()
        specialService = GameSpecialService()
    }
    
    func registerSpecial(_ special: GameSpecialProtocol) {
        print("⭐️ Registering special card")
        specialService = specialService.withSpecial(special)
    }
    
    func isSpecial(_ item: WordItemModel) -> Bool {
        specialService.isSpecial(item)
    }
    
    func getSpecialModifiers() -> [AnyViewModifier] {
        specialService.getModifiers()
    }
    
    // MARK: - Game Results
    func handleGameResult(_ result: GameResultProtocol) {
        print("🎯 Handling game result: correct=\(result.isCorrect), score=\(result)")
        
        // Обрабатываем результат игры
        gameHandler.handleResult(result)
        
        // Обновляем статистику слова
        let updatedWord = updateWordStats(
            word: result.word,
            isCorrect: result.isCorrect
        )
        
        // Сохраняем обновленное слово
        update(updatedWord) { [weak self] result in
            switch result {
            case .success:
                print("📝 Word stats updated successfully: \(updatedWord.toString())")
            case .failure(let error):
                print("❌ Failed to update word stats: \(error.localizedDescription)")
                self?.handleError(error)
            }
        }
        
        // Уведомляем об изменении счета
        if let scoreResult = stats.lastScoreResult {
            print("💯 Score change: \(scoreResult.total) (reason: \(scoreResult.reason))")
            onScoreChange?(scoreResult.total, scoreResult.reason)
        }
    }
    
    func setFrame(_ newFrame: AppFrameModel) {
        print("🖼 Setting frame to: \(newFrame)")
        self.frame = newFrame
    }
    
    private func updateWordStats(word: WordItemModel, isCorrect: Bool) -> WordItemModel {
        var updatedWord = word
        
        if isCorrect {
            updatedWord.success += 1
        } else {
            updatedWord.fail += 1
        }
        
        updatedWord.weight = gameHandler.calculateWordWeight(
            success: updatedWord.success,
            fail: updatedWord.fail
        )
        
        print("📊 Updated word stats: success=\(updatedWord.success), fail=\(updatedWord.fail), weight=\(updatedWord.weight)")
        return updatedWord
    }
    
    private func update(_ word: WordItemModel, completion: @escaping (Result<Void, Error>) -> Void) {
        print("💾 Saving word update to database: \(word.toString())")
        performDatabaseOperation(
            { try self.repository.update(word) },
            successHandler: { _ in },
            source: .wordUpdate,
            frame: frame,
            message: "Failed to update word",
            additionalInfo: ["word": word.toString()],
            completion: completion
        )
    }
    
    private func handleError(_ error: Error) {
        print("❌ Error in GameActionViewModel: \(error.localizedDescription)")
    }
    
    deinit {
        print("🎮 GameActionViewModel: Deinitializing")
        cancellables.removeAll()
    }
}
