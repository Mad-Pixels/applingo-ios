/// Enum representing available API sort types for data sorting.
enum ApiSortType: String, CaseIterable {
    /// Sort by creation date.
    case date = "date"
    
    /// Sort by rating.
    case rating = "rating"
    
    /// Provides a localized name for each sort type.
    var name: String {
        switch self {
        case .date:
            return LocaleManager.shared.localizedString(
                for: "sort.api.DictionarySortByDate"
            )
        case .rating:
            return LocaleManager.shared.localizedString(
                for: "sort.api.DictionarySortByRating"
            )
        }
    }
}
