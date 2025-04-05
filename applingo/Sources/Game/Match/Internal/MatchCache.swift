import Foundation

internal final class MatchCache: GameCache<DatabaseModelWord> {
    var usedWordIDs: Set<Int> = []

    override func getGroupKeyImpl(_ item: DatabaseModelWord) -> String {
        return item.subcategory
    }

    override func validateItemImpl(_ item: DatabaseModelWord, _ selected: [DatabaseModelWord]) -> Bool {
        if let id = item.id, usedWordIDs.contains(id) {
            return false
        }

        return !selected.contains { existing in
            existing.frontText == item.frontText ||
            existing.frontText == item.backText ||
            existing.backText == item.frontText ||
            existing.backText == item.backText
        }
    }
}
