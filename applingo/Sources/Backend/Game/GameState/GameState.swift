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
    /// The current state specific to the time mode (e.g., remaining time in seconds).
    @Published var timeState: GameStateUtilsTimer?
    /// Game over flag (if `true` close game).
    @Published var isGameOver: Bool = false
    
    /// A structure representing the state for the survival game mode.
    internal struct SurvivalState {
        /// The number of lives remaining.
        var lives: Int
    }
    
    /// A structure representing the state for the time-based game mode.
    internal struct TimeState {
        /// The amount of time left in seconds.
        var timeLeft: TimeInterval
    }
}
