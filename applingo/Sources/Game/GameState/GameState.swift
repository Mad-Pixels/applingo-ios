import SwiftUI

final class GameState: ObservableObject {
    /// The currently selected game mode, if any.
    @Published var currentMode: GameModeType?
    
    /// The current state specific to the survival mode (e.g., remaining lives).
    @Published var survivalState: SurvivalState?
    
    /// The current state specific to the time mode, managed by a timer utility.
    @Published var timeState: GameStateUtilsTimer?
    
    /// Game over flag (if `true` the game should be closed).
    @Published var isGameOver: Bool = false
    
    /// Show game result flag, if `true` open `/Screen/GameResult`.
    @Published var showResults: Bool = false
    
    /// Show no-words flag, if `true` open modal when game cannot be initialized.
    @Published var showNoWords: Bool = false
    
    /// Set a reason why game was ended.
    @Published var endReason: GameStateEndReasonType?
    
    /// This method resets any previous state and configures the state according to the selected game mode.
    /// - Parameter mode: The game mode to initialize the state for.
    func initialize(for mode: GameModeType) {
        currentMode = mode
        
        showResults = false
        showNoWords = false
        isGameOver = false
        
        survivalState = nil
        timeState = nil
        endReason = nil
        
        switch mode {
        case .survival:
            survivalState = SurvivalState(lives: AppStorage.shared.gameLives)
        case .time:
            let timer = GameStateUtilsTimer(duration: AppStorage.shared.gameDuration)
            
            timer.onTimeUp = { [weak self] in
                self?.end(reason: .timeUp)
            }
            timer.start()
            
            timeState = timer
        case .practice:
            break
        }
    }
    
    /// Ends the game with the given reason.
    /// - Parameter reason: The reason why the game is ending.
    func end(reason: GameStateEndReasonType) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            if case .time = self.currentMode {
                self.timeState?.stop()
            }
            self.endReason = reason
            
            switch reason {
            case .timeUp, .noLives:
                self.showResults = true
            case .userQuit:
                self.isGameOver = true
            }
            
            Logger.debug("[GameState]: Game ended", metadata: [
                "reason": String(describing: reason),
                "mode": String(describing: self.currentMode)
            ])
        }
    }
}
