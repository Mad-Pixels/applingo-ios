import Foundation

/// Provides localized strings for the Game Tab view.
final class GameTabLocale: ObservableObject {
    // MARK: - Localized Keys
    private enum LocalizedKey: String {
        case score = "component.GameTab.description.score"
        case streak = "component.GameTab.description.streak"
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
    /// Returns a localized string for the specified key.
    private static func localizedString(for key: LocalizedKey) -> String {
        return LocaleManager.shared.localizedString(for: key.rawValue)
    }
    
    // MARK: - Notification Handler
    @objc private func localeDidChange() {
        screenScore = Self.localizedString(for: .score)
        screenStreak = Self.localizedString(for: .streak)
    }
}
