import SwiftUI

/// An observable class that encapsulates the current state of the game.
///
/// `GameState` holds the current game mode along with any additional state needed
/// for specific game modes, such as remaining lives in survival mode or remaining time in time mode.
/// As an `ObservableObject`, changes to its published properties will automatically update any subscribed SwiftUI views.
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
    
    /// Initializes or resets the game state for the given mode.
    ///
    /// This method resets any previous state and configures the state according to the selected game mode.
    /// - Parameter mode: The game mode to initialize the state for.
    func initialize(for mode: GameModeType) {
        survivalState = nil
        timeState = nil
        
        currentMode = mode
        isGameOver = false
        showResults = false
        showNoWords = false
        endReason = nil
        
        switch mode {
        case .survival:
            survivalState = SurvivalState(lives: DEFAULT_SURVIVAL_LIVES)
        case .time:
            let timer = GameStateUtilsTimer(duration: DEFAULT_TIME_DURATION)
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
    ///
    /// This method stops the timer (if running), sets the game over flag to `true`,
    /// and logs the reason for ending the game.
    ///
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
