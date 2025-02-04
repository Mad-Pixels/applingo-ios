import Foundation

/// Provides localized strings for the Dictionary Remote List view.
final class GameTabLocale: ObservableObject {
    
    // MARK: - Private Strings
    
    private enum Strings {
        static let score = "component.GameTab.description.score"
        static let streak = "component.GameTab.description.streak"
    }
    
    // MARK: - Published Properties
    
    @Published private(set) var screenScore: String
    @Published private(set) var screenStreak: String
    
    // MARK: - Initialization
    
    init() {
        self.screenScore = Self.localizedString(for: .score)
        self.screenStreak = Self.localizedString(for: .streak)
        
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
    
    // MARK: - Localization Helper
    
    private enum LocalizedKey {
        case score
        case streak
        
        var key: String {
            switch self {
            case .score: return Strings.score
            case .streak: return Strings.streak
            }
        }
    }
    
    private static func localizedString(for key: LocalizedKey) -> String {
        return LocaleManager.shared.localizedString(for: key.key)
    }
    
    // MARK: - Notification Handler
    
    @objc private func localeDidChange() {
        screenScore = Self.localizedString(for: .score)
        screenStreak = Self.localizedString(for: .streak)
    }
}
