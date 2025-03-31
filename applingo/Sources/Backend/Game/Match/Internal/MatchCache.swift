import Foundation

internal final class MatchCache: GameCache<DatabaseModelWord, QuizModelCard> {
    override func getGroupKeyImpl(_ item: DatabaseModelWord) -> String {
        return item.subcategory
    }
    
    override func validateItemImpl(_ item: DatabaseModelWord, _ selected: [DatabaseModelWord]) -> Bool {
        return !selected.contains { existing in
            existing.frontText == item.frontText ||
            existing.frontText == item.backText ||
            existing.backText == item.frontText ||
            existing.backText == item.backText
        }
    }
}
