import Foundation

/// A model that represents a scoring component for a game answer.
///
/// This structure is used to store the score value along with its associated type,
/// which determines the visual representation (such as an icon) in the UI.
/// It also provides a computed property to display the score with the appropriate sign.
struct GameScoringScoreAnswerModel: Identifiable, Equatable {
    
    /// A unique identifier for the scoring model instance.
    internal let id = UUID()
    
    /// The score value for this particular scoring event.
    internal let value: Int
    
    /// The type of the score, which is used to determine the corresponding icon.
    internal let type: ScoreType
    
    /// A computed property that returns a "+" sign if the value is positive or "–" if negative.
    var sign: String {
        value >= 0 ? "+" : "-"
    }
}
