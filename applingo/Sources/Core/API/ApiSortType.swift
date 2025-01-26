enum ApiSortType: String, CaseIterable {
    case date = "date"
    case rating = "rating"
    
    var name: String {
        switch self {
        case .date: return LanguageManager.shared.localizedString(for: "DateCreated")
        case .rating: return LanguageManager.shared.localizedString(for: "Rating")
        }
    }
}
