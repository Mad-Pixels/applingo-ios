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
            return "52"
        case .streakBonus:
            return "53"
        case .fastResponse:
            return "54"
        case .specialCard:
            return "55"
        case .penalty:
            return "56"
        case .multiple:
            return "57"
        }
    }
}
