import SwiftUI

/// The minimum allowed number of lives in survival mode.
let DEFAULT_SURVIVAL_LIVES_MIN = 3

/// The maximum allowed number of lives in survival mode.
let DEFAULT_SURVIVAL_LIVES_MAX = 6

/// The minimum allowed duration (in seconds) for time-based game mode.
let DEFAULT_TIME_DURATION_MIN: TimeInterval = 90

/// The maximum allowed duration (in seconds) for time-based game mode.
let DEFAULT_TIME_DURATION_MAX: TimeInterval = 150

// The special card chance.
let SPECIAL_CARD_CHANCE: Double = 0.2

let AVAILABLE_LIVES = [3, 4, 5, 6]
let AVAILABLE_TIME_DURATIONS: [TimeInterval] = [90, 120, 150]
