import Foundation

/// Provides localized strings for the Home view.
final class HomeLocale: ObservableObject {
    
    // MARK: - Private Strings
    
    private enum Strings {
        static let quiz = "Quiz"
        static let matchHunt = "MatchHunt"
        static let verifyIt = "VerifyIt"
    }
    
    // MARK: - Published Properties
    
    /// Title for the quiz button.
    @Published private(set) var quizTitle: String
    /// Title for the match hunt button.
    @Published private(set) var matchHuntTitle: String
    /// Title for the verify it button.
    @Published private(set) var verifyItTitle: String
    
    // MARK: - Initialization
    
    init() {
        self.quizTitle = Self.localizedString(for: .quizTitle)
        self.matchHuntTitle = Self.localizedString(for: .matchHuntTitle)
        self.verifyItTitle = Self.localizedString(for: .verifyItTitle)
        
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
        case quizTitle
        case matchHuntTitle
        case verifyItTitle
        
        var key: String {
            switch self {
            case .quizTitle: return Strings.quiz
            case .matchHuntTitle: return Strings.matchHunt
            case .verifyItTitle: return Strings.verifyIt
            }
        }
        
        var capitalized: Bool {
            true
        }
    }
    
    /// Retrieves a localized string for the given key.
    private static func localizedString(for key: LocalizedKey) -> String {
        let string = LocaleManager.shared.localizedString(for: key.key)
        return key.capitalized ? string.capitalizedFirstLetter : string
    }
    
    // MARK: - Notification Handler
    
    @objc private func localeDidChange() {
        quizTitle = Self.localizedString(for: .quizTitle)
        matchHuntTitle = Self.localizedString(for: .matchHuntTitle)
        verifyItTitle = Self.localizedString(for: .verifyItTitle)
    }
}
