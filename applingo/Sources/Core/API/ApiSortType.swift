enum ApiSortType: String, CaseIterable {
    case date = "date"
    case rating = "rating"
    
    var name: String {
        switch self {
        case .date: return LocaleManager.shared.localizedString(for: "DateCreated")
        case .rating: return LocaleManager.shared.localizedString(for: "Rating")
        }
    }
}
