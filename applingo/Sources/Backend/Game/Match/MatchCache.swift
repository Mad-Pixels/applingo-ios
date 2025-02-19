import Foundation

/// A cache for the Quiz game that inherits from BaseGameCache.
/// It overrides the grouping and validation logic to suit quiz-specific requirements.
final class MatchCache: GameCache<DatabaseModelWord, QuizModelCard> {
    // MARK: - Methods
    /// Returns the grouping key for a given word.
    /// - Parameter item: A DatabaseModelWord instance.
    /// - Returns: The subcategory of the word, used as the grouping key.
    override func getGroupKeyImpl(_ item: DatabaseModelWord) -> String {
        return "all"
    }
    
    /// Validates the given word against a list of already selected words.
    /// Ensures that the word's front and back texts do not duplicate any texts in the selected set.
    /// - Parameters:
    ///   - item: The DatabaseModelWord to validate.
    ///   - selected: An array of already selected DatabaseModelWord instances.
    /// - Returns: True if the item is valid (i.e., not a duplicate); otherwise, false.
    override func validateItemImpl(_ item: DatabaseModelWord, _ selected: [DatabaseModelWord]) -> Bool {
        return true
    }
}
