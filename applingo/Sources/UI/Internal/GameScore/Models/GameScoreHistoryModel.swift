import SwiftUI

/// A model representing a single entry in the score history for the game score view.
///
/// Each instance stores the score details along with visual properties used for animations,
/// such as opacity, vertical offset, and scale. This model conforms to `Identifiable` so that
/// it can be uniquely identified in lists or animations, and to `Equatable` to allow comparisons
/// between score history entries.
struct ScoreHistoryModel: Identifiable, Equatable {
    /// A unique identifier for the score history entry.
    let id = UUID()
    /// The scoring model associated with this history entry, containing the score value,
    /// its type, and computed sign.
    let score: GameScoringScoreAnswerModel
    /// The current opacity of the score entry in the UI.
    var opacity: Double
    /// The vertical offset used to animate the score entry.
    var offset: CGFloat
    /// The scale factor applied to the score entry for animation effects.
    var scale: CGFloat
    
    /// Compares two `ScoreHistoryModel` instances for equality.
    /// Two entries are considered equal if their score, opacity, offset, and scale properties are identical.
    static func == (lhs: ScoreHistoryModel, rhs: ScoreHistoryModel) -> Bool {
        lhs.score == rhs.score &&
        lhs.opacity == rhs.opacity &&
        lhs.offset == rhs.offset &&
        lhs.scale == rhs.scale
    }
}
