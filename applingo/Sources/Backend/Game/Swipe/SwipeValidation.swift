import SwiftUI

/// Предоставляет логику валидации для игры Swipe.
/// Этот класс расширяет `BaseGameValidation` и реализует валидацию ответа путем сравнения
/// ответа пользователя (свайп влево/вправо) с правильным ответом из текущей карточки.
final class SwipeValidation: BaseGameValidation {
    // MARK: - Properties
    /// Текущая карточка, используемая для валидации.
    /// Эта карточка содержит правильный ответ, с которым будет сравниваться ответ пользователя.
    private var currentCard: SwipeModelCard?
    private var currentWord: DatabaseModelWord?
    
    // MARK: - Methods
    /// Устанавливает текущую карточку и связанное с ней слово для валидации ответа.
    /// - Parameters:
    ///   - currentCard: Экземпляр `SwipeModelCard`, представляющий текущую карточку.
    ///   - currentWord: Экземпляр `DatabaseModelWord`, связанный с текущей карточкой.
    func setCurrentCard(currentCard: SwipeModelCard, currentWord: DatabaseModelWord) {
        self.currentCard = currentCard
        self.currentWord = currentWord
    }
    
    /// Проверяет предоставленный ответ с правильным ответом текущей карточки.
    ///
    /// Метод пытается привести предоставленный ответ к типу `Bool` и сравнивает его с
    /// флагом isCorrectPair, хранящимся в текущей карточке. Если приведение не удается или
    /// текущая карточка не установлена, метод возвращает `.incorrect`.
    ///
    /// - Parameter answer: Ответ пользователя (true - свайп вправо, false - свайп влево).
    /// - Returns: `GameValidationResult`, указывающий правильный ответ (`.correct`)
    ///   или нет (`.incorrect`).
    override func validateAnswer(answer: Any) -> GameValidationResult {
        guard let answer = answer as? Bool,
              let card = currentCard else {
            return .incorrect
        }
        return answer == card.isCorrectPair ? .correct : .incorrect
    }
    
    /// Возвращает текущее слово, связанное с карточкой для целей валидации.
    /// - Returns: Опциональный экземпляр `DatabaseModelWord`, представляющий текущее слово,
    ///   или `nil` если текущее слово не установлено.
    override func getCurrentWord() -> DatabaseModelWord? {
        return currentWord
    }
}
