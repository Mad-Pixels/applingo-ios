import Foundation

/// A cache for the Quiz game that inherits from BaseGameCache.
/// It overrides the grouping and validation logic to suit quiz-specific requirements.
final class MatchCache: GameCache<DatabaseModelWord, QuizModelCard> {
    override func getGroupKeyImpl(_ item: DatabaseModelWord) -> String {
        Logger.debug("[MatchCache]: Getting group key for word", metadata: [
            "word": item.frontText,
            "subcategory": item.subcategory
        ])
        return item.subcategory
    }
    
    override func validateItemImpl(_ item: DatabaseModelWord, _ selected: [DatabaseModelWord]) -> Bool {
        Logger.debug("[MatchCache]: Validating item", metadata: [
            "word": item.frontText,
            "selectedCount": String(selected.count)
        ])
        
        // Проверяем, что нет дубликатов по frontText и backText
        let hasDuplicate = selected.contains { existingWord in
            existingWord.frontText == item.frontText ||
            existingWord.frontText == item.backText ||
            existingWord.backText == item.frontText ||
            existingWord.backText == item.backText
        }
        
        Logger.debug("[MatchCache]: Validation result", metadata: [
            "word": item.frontText,
            "isValid": String(!hasDuplicate)
        ])
        
        return !hasDuplicate
    }
}
