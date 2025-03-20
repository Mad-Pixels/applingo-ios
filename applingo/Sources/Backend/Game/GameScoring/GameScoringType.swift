enum ScoreType {
    case regular
    case streakBonus
    case fastResponse
    case specialCard
    case penalty
    case multiple

    var iconName: String {
        switch self {
        case .regular:
            return "answer_ok"
        case .streakBonus:
            return "answer_streak"
        case .fastResponse:
            return "answer_fast"
        case .specialCard:
            return "answer_special"
        case .penalty:
            return "answer_wrong"
        case .multiple:
            return "answer_multiple"
        }
    }
}
