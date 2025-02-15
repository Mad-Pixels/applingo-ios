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
            return "star.fill"
        case .streakBonus:
            return "flame.fill"
        case .fastResponse:
            return "bolt.fill"
        case .specialCard:
            return "sparkles"
        case .penalty:
            return "minus.circle.fill"
        case .multiple:
            return "plus.circle.fill"
        }
    }
}
