import Foundation
import Combine
import SwiftUI

final class GameActionViewModel: BaseDatabaseViewModel {
    @Published private(set) var stats: GameStatsModel
    @Published private(set) var gameMode: GameModeEnum = .practice
    @Published private(set) var isGameActive = false
    
    private let gameHandler: GameHandler
    private let scoreCalculator: GameScoreCalculator
    private let wordRepository: WordRepositoryProtocol
    
    private var cancellables = Set<AnyCancellable>()
    private var frame: AppFrameModel = .main
    private var specialService: GameSpecialService {
        didSet {
            gameHandler.updateSpecialService(specialService)
        }
    }
    var onScoreChange: ((Int, ScoreAnimationReason) -> Void)?
    var specialServiceProvider: GameSpecialService {
        specialService
    }
    
    override init() {
        guard let dbQueue = DatabaseManager.shared.databaseQueue else {
            fatalError("Database is not connected")
        }
        self.wordRepository = RepositoryWord(dbQueue: dbQueue)
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
    
    func setGameMode(_ mode: GameModeEnum) {
        gameHandler.setGameMode(mode)
    }
    
    func startGame() {
        gameHandler.startGame(mode: gameMode)
    }
    
    func endGame() {
        gameHandler.endGame()
        specialService = GameSpecialService()
    }
    
    func registerSpecial(_ special: GameSpecialProtocol) {
        specialService = specialService.withSpecial(special)
    }
    
    func isSpecial(_ item: WordItemModel) -> Bool {
        specialService.isSpecial(item)
    }
    
    func getSpecialModifiers() -> [AnyViewModifier] {
        specialService.getModifiers()
    }
    
    func handleGameResult(_ result: GameResultProtocol) {
        gameHandler.handleResult(result)
        
        let updatedWord = updateWordStats(
            word: result.word,
            isCorrect: result.isCorrect
        )
        update(updatedWord) { result in }
        if let scoreResult = stats.lastScoreResult {
            onScoreChange?(scoreResult.total, scoreResult.reason)
        }
    }
    
    func setFrame(_ newFrame: AppFrameModel) {
        self.frame = newFrame
    }
    
    private func setupBindings() {
        gameHandler.$stats
            .sink { [weak self] newStats in
                self?.stats = newStats
            }
            .store(in: &cancellables)
        gameHandler.$gameMode
            .sink { [weak self] newMode in
                self?.gameMode = newMode
            }
            .store(in: &cancellables)
        gameHandler.$isGameActive
            .sink { [weak self] isActive in
                self?.isGameActive = isActive
            }
            .store(in: &cancellables)
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
        return updatedWord
    }
    
    private func update(_ word: WordItemModel, completion: @escaping (Result<Void, Error>) -> Void) {
        performDatabaseOperation(
            { try self.wordRepository.update(word) },
            successHandler: { _ in },
            source: .wordUpdate,
            frame: frame,
            message: "Failed to update word",
            additionalInfo: ["word": word.toString()],
            completion: completion
        )
    }
    
    deinit {
        cancellables.removeAll()
    }
}
