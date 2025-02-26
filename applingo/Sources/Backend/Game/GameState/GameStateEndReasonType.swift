/// An enumeration representing the possible reasons for ending the game.
///
/// Each case indicates a different scenario under which the game may conclude:
/// - `timeUp`: The game ends because the allotted time has expired.
/// - `noLives`: The game ends because the player has run out of lives (relevant for survival mode).
/// - `userQuit`: The game ends because the player voluntarily chose to quit.
enum GameStateEndReasonType {
    case timeUp
    case noLives
    case userQuit
}
