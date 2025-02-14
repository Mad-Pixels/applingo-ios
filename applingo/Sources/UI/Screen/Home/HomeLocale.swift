import Foundation

/// Provides localized strings for the Home view.
final class HomeLocale: ObservableObject {
    
    // MARK: - Localized Keys
    private enum LocalizedKey: String {
        case gameQuiz = "screen.home.game.quiz"
        case gameMatchup = "screen.home.game.matchup"
        case gameSwipe = "screen.home.game.swipe"
    }
    
    // MARK: - Published Properties
    
    /// Title for the quiz button.
    @Published private(set) var screenGameQuiz: String
    @Published private(set) var screenGameMatchup: String
    @Published private(set) var screenGameSwipe: String
    
    // MARK: - Initialization
    
    init() {
        self.screenGameQuiz = Self.localizedString(for: .gameQuiz)
        self.screenGameMatchup = Self.localizedString(for: .gameMatchup)
        self.screenGameSwipe = Self.localizedString(for: .gameSwipe)
        
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
    
    /// Retrieves a localized string for the given key.
    private static func localizedString(for key: LocalizedKey) -> String {
        return LocaleManager.shared.localizedString(for: key.rawValue).uppercased()
    }
    
    // MARK: - Notification Handler
    
    @objc private func localeDidChange() {
        screenGameQuiz = Self.localizedString(for: .gameQuiz)
        screenGameMatchup = Self.localizedString(for: .gameMatchup)
        screenGameSwipe = Self.localizedString(for: .gameSwipe)
    }
}
