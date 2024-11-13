import Foundation
import Combine

import Foundation
import Combine

final class GameActionViewModel: BaseDatabaseViewModel {
    private let gameHandler: GameHandler
    private let repository: WordRepositoryProtocol
    private var frame: AppFrameModel = .main
    private var cancellables = Set<AnyCancellable>()
    
    @Published private(set) var stats: GameStatsModel = GameStatsModel()
    @Published private(set) var gameMode: GameMode = .practice
    @Published private(set) var isGameActive = false
    
    init(repository: WordRepositoryProtocol) {
        self.repository = repository
        self.gameHandler = GameHandler()
        super.init()
        setupBindings()
    }
    
    private func setupBindings() {
        gameHandler.$stats.assign(to: &$stats)
        gameHandler.$gameMode.assign(to: &$gameMode)
        gameHandler.$isGameActive.assign(to: &$isGameActive)
    }
    
    func setGameMode(_ mode: GameMode) {
        gameHandler.setGameMode(mode)
    }
    
    func startGame() {
        gameHandler.startGame(mode: gameMode)
    }
    
    func endGame() {
        gameHandler.endGame()
    }
    
    func handleGameResult(_ result: GameResultProtocol) {
        gameHandler.handleResult(result)
        let updatedWord = updateWordStats(
            word: result.word,
            isCorrect: result.isCorrect
        )
        update(updatedWord) { _ in }
    }
    
    func setFrame(_ newFrame: AppFrameModel) {
        self.frame = newFrame
    }
    
    deinit {
        cancellables.removeAll()
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
            { try self.repository.update(word) },
            successHandler: { _ in },
            source: .wordUpdate,
            frame: frame,
            message: "Failed to update word",
            additionalInfo: ["word": word.toString()],
            completion: completion
        )
    }
}
