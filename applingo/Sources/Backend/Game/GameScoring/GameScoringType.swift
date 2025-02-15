/// An enumeration that defines the various types of score components in the game.
///
/// Each case represents a distinct scoring category that may influence the visual representation
/// (such as an icon) and the calculation logic associated with the score.
enum ScoreType {
    /// Represents the base or regular score for a correct answer.
    case regular
    
    /// Represents an additional bonus awarded for achieving a series of consecutive correct answers.
    case streakBonus
    
    /// Represents a bonus awarded for providing a fast response.
    case fastResponse
    
    /// Represents a bonus awarded when a special card is used during the game.
    case specialCard

    /// A computed property that returns the name of the icon associated with each score type.
    ///
    /// Use this property to retrieve the appropriate icon identifier for UI display.
    var iconName: String {
        switch self {
        case .regular:
            return "regular_score_icon"
        case .streakBonus:
            return "streak_bonus_icon"
        case .fastResponse:
            return "fast_response_icon"
        case .specialCard:
            return "special_card_icon"
        }
    }
}
