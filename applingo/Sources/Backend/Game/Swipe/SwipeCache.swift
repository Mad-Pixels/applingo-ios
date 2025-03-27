import Foundation

/// Кэш для игры Swipe, наследующийся от BaseGameCache.
/// Переопределяет логику группировки и валидации для соответствия требованиям игры Swipe.
final class SwipeCache: GameCache<DatabaseModelWord, SwipeModelCard> {
    // MARK: - Methods
    /// Возвращает ключ группировки для данного слова.
    /// - Parameter item: Экземпляр DatabaseModelWord.
    /// - Returns: Подкатегория слова, используемая как ключ группировки.
    override func getGroupKeyImpl(_ item: DatabaseModelWord) -> String {
        return item.subcategory
    }
    
    /// Проверяет данное слово против списка уже выбранных слов.
    /// Гарантирует, что frontText и backText слова не дублируют тексты в выбранном наборе.
    /// - Parameters:
    ///   - item: DatabaseModelWord для проверки.
    ///   - selected: Массив уже выбранных экземпляров DatabaseModelWord.
    /// - Returns: True, если элемент валиден (т.е., не дубликат); иначе false.
    override func validateItemImpl(_ item: DatabaseModelWord, _ selected: [DatabaseModelWord]) -> Bool {
        return !selected.contains { existing in
            existing.frontText == item.frontText ||
            existing.frontText == item.backText ||
            existing.backText == item.frontText ||
            existing.backText == item.backText
        }
    }
}
