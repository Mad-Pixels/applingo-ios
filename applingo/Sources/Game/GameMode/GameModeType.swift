/// Each case represents a distinct mode of play:
/// - `practice`: A relaxed mode without penalties, ideal for learning and practice.
/// - `survival`: A challenging mode where players have limited lives.
/// - `time`: A mode where players must answer within a specific time limit.
enum GameModeType {
    case practice
    case survival
    case time
}
