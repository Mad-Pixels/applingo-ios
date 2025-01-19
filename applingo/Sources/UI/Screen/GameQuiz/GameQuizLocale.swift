import Foundation

final class GameQuizLocale: ObservableObject {
    private enum Strings {
        static let learn = "Learn"
    }
    
    @Published private(set) var navigationTitle: String
    
    init() {
        self.navigationTitle = Self.localizedString(for: .navigationTitle)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(localeDidChange),
            name: LocaleManager.localeDidChangeNotification,
            object: nil
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private enum LocalizedKey {
        case navigationTitle
        
        var key: String {
            switch self {
            case .navigationTitle: return Strings.learn
            }
        }
        
        var capitalized: Bool {
            switch self {
            case .navigationTitle: return true
            default: return false
            }
        }
    }
    
    private static func localizedString(for key: LocalizedKey) -> String {
        let string = LocaleManager.shared.localizedString(for: key.key)
        return key.capitalized ? string.capitalizedFirstLetter : string
    }
    
    @objc private func localeDidChange() {
        navigationTitle = Self.localizedString(for: .navigationTitle)
    }
}
