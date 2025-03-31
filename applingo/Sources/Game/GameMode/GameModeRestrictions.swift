import SwiftUI

/// A structure defining the restrictions or limits applied to a game mode.
/// - Parameters:
///   - lives: An optional integer representing the number of lives available in the mode.
///   - timeLimit: An optional time interval (in seconds) that sets the time constraint for the mode.
struct GameModeRestrictions {
    let lives: Int?
    let timeLimit: TimeInterval?
}
