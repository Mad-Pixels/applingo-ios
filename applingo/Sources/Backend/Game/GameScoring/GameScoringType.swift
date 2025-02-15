enum ScoreType {
    case regular        // Обычные очки
    case streakBonus    // Бонус за серию правильных ответов
    case fastResponse   // Бонус за быстрый ответ
    case specialCard    // Бонус за использование специальной карточки

    /// Возвращает имя иконки для данного типа.
    var iconName: String {
        switch self {
        case .regular:
            return "regular_score_icon"    // замените на имя вашей иконки
        case .streakBonus:
            return "streak_bonus_icon"       // замените на имя вашей иконки
        case .fastResponse:
            return "fast_response_icon"      // замените на имя вашей иконки
        case .specialCard:
            return "special_card_icon"       // замените на имя вашей иконки
        }
    }
}
