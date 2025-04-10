enum WordSortOption: String, CaseIterable, Identifiable {
    case `default`
    case az
    case za
    case incorrectMin
    case incorrectMax
    case weightMin
    case weightMax

    var id: String { rawValue }

    var iconName: String {
        switch self {
        case .default: return "line.3.horizontal.decrease.circle"
        case .az: return "textformat.abc"
        case .za: return "textformat.abc.dottedunderline"
        case .incorrectMin: return "arrow.down.circle"
        case .incorrectMax: return "arrow.up.circle"
        case .weightMin: return "scalemass"
        case .weightMax: return "scalemass.fill"
        }
    }
}
