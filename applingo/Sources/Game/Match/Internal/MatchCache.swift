import Foundation

internal final class MatchCache: GameCache<DatabaseModelWord> {
    var usedWordIDs: Set<Int> = []

    override func getGroupKeyImpl(_ item: DatabaseModelWord) -> String {
        return item.subcategory
    }

    override func validateItemImpl(_ item: DatabaseModelWord, _ selected: [DatabaseModelWord]) -> Bool {
        if let id = item.id, usedWordIDs.contains(id) {
            Logger.warning("[MatchCache]: Word already on board", metadata: [
                "wordId": String(id),
                "word": item.frontText
            ])
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
