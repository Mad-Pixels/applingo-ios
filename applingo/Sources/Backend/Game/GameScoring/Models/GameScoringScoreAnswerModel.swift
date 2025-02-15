import Foundation

struct GameScoringScoreAnswerModel: Identifiable {
    internal let id = UUID()
    internal let value: Int
    internal let type: ScoreType
    
    var sign: String {
        value >= 0 ? "+" : "-"
    }
}
