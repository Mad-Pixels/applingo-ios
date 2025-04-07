import SwiftUI

/// A protocol defining the core interface for a game.
/// Conforming types must provide properties for game configuration and methods for
/// updating game stats, validating answers, managing game modes, controlling game flow,
/// and generating the game view.
protocol AbstractGame: ObservableObject {
    associatedtype ValidationAnswer
    
    /// The game validation object.
    var validation: any AbstractGameValidation { get }
    /// The game statistics object.
    var stats: GameStats { get }
    /// The available game modes.
    var availableModes: [GameModeType] { get }
    /// The scoring mechanism.
    var scoring: GameScoring { get }
    /// The game theme.
    var theme: GameTheme { get }
    /// The current game state.
    var state: GameState { get }
    /// The game type.
    var type: GameType { get }
    /// A flag indicating whether the game is ready to play.
    var isReadyToPlay: Bool { get }
    /// The game settings.
    var settings: GameSettings { get }
    
    /// Updates the game statistics based on whether the answer was correct,
    /// the response time, and any applied bonus.
    /// - Parameters:
    ///   - correct: Whether the answer was correct.
    ///   - responseTime: Time taken by the user.
    ///   - specialBonus: Optional bonus used in this answer.
    func updateStats(correct: Bool, responseTime: TimeInterval, specialBonus: GameSpecialBonus?)
    
    /// Validates the provided answer.
    /// - Parameter answer: The answer to validate.
    /// - Returns: A GameValidationResult indicating if the answer is correct or not.
    func validateAnswer(_ answer: ValidationAnswer, selected: String?) -> GameValidationResult
    
    /// Returns the game mode model corresponding to the specified game mode type.
    /// - Parameter type: The game mode type.
    /// - Returns: A GameModeModel for the given mode.
    func getModeModel(_ type: GameModeType) -> GameModeModel
    
    /// Retrieves items for the game.
    /// - Parameter count: Number of items to retrieve.
    /// - Returns: Array of items if available, nil otherwise.
    func getItems(_ count: Int) -> [any Hashable]?
    
    /// Removes an item from the game's cache.
    /// - Parameter item: The item to remove.
    func removeItem(_ item: any Hashable)
    
    /// Indicates whether the game is currently loading cache.
    var isLoadingCache: Bool { get }
    
    /// Starts the game with the specified mode.
    /// - Parameter mode: The selected game mode.
    func start()
    
    /// Ends the game.
    func end()
    
    /// Generates and returns the game view.
    /// - Returns: An AnyView representing the game interface.
    @ViewBuilder
    func makeView() -> AnyView
}
