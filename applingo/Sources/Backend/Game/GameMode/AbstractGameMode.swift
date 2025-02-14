import SwiftUI

/// A protocol that defines the core requirements for a game mode.
///
/// Conforming types must provide a game mode type, applicable restrictions, and logic to validate the current
/// game state as well as determine if the game should end based on that state.
///
/// - Properties:
///   - `type`: The specific type of game mode (e.g., practice, survival, or time).
///   - `restrictions`: Constraints for the mode, such as a time limit or a number of lives.
/// - Methods:
///   - `validateGameState(_:)`: Validates whether the current game state meets the requirements to continue playing.
///   - `shouldEndGame(_:)`: Determines if the game should end based on the current game state.
protocol AbstractGameMode {
    /// The type of game mode.
    var type: GameModeType { get }
    
    /// The restrictions or limits imposed by the game mode.
    var restrictions: GameModeRestrictions { get }
    
    /// Validates if the current game state is acceptable for continuing the game.
    ///
    /// - Parameter state: The current state of the game.
    /// - Returns: A Boolean value indicating whether the game state is valid.
    func validateGameState(_ state: GameState) -> Bool
    
    /// Determines whether the game should end based on the current state.
    ///
    /// - Parameter state: The current state of the game.
    /// - Returns: A Boolean value indicating whether the game should be ended.
    func shouldEndGame(_ state: GameState) -> Bool
}
