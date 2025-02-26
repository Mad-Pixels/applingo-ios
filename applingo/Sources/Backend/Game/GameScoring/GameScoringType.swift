enum ScoreType {
    case regular        // Обычные очки
    case streakBonus    // Бонус за серию правильных ответов
    case fastResponse   // Бонус за быстрый ответ
    case specialCard    // Бонус за использование специальной карточки
    case penalty        // Штраф за неправильный ответ
    case multiple       // Ситуация, когда начислено несколько бонусов одновременно

    /// Возвращает имя иконки для данного типа.
    var iconName: String {
        switch self {
        case .regular:
            return "answer_correct"
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
