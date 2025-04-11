enum WordSortOption: String, CaseIterable, Identifiable {
    case `default`
    case az
    case za
    case weightMin
    case weightMax
    case createdMax
    
    var id: String { rawValue }

    var iconName: String {
        switch self {
        case .default: return "grid.circle"
        case .createdMax: return "calendar.circle"
        case .weightMin: return "arrow.up.circle"
        case .weightMax: return "arrow.down.circle"
        case .az: return "character.circle"
        case .za: return "z.circle"
        }
    }
}
