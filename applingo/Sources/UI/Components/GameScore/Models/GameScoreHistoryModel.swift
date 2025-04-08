import SwiftUI

/// A model representing a single entry in the score history for the game score view.
///
/// Each instance stores the score details along with visual properties used for animations,
/// such as opacity, vertical offset, and scale. This model conforms to `Identifiable` so that
/// it can be uniquely identified in lists or animations, and to `Equatable` to allow comparisons
/// between score history entries.
struct ScoreHistoryModel: Identifiable, Equatable {
    let id = UUID()

    let score: GameScoringScoreAnswerModel
    var opacity: Double
    var offset: CGFloat
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
