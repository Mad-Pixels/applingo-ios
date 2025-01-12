import Foundation

final class HomeLocale: ObservableObject {
    private enum Strings {
        static let quiz = "Quiz"
        static let matchHunt = "MatchHunt"
        static let verifyIt = "VerifyIt"
    }
    
    @Published private(set) var quizTitle: String
    @Published private(set) var matchHuntTitle: String
    @Published private(set) var verifyItTitle: String
    
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
    
    private static func localizedString(for key: LocalizedKey) -> String {
        let string = LocaleManager.shared.localizedString(for: key.key)
        return key.capitalized ? string.capitalizedFirstLetter : string
    }
    
    @objc private func localeDidChange() {
        quizTitle = Self.localizedString(for: .quizTitle)
        matchHuntTitle = Self.localizedString(for: .matchHuntTitle)
        verifyItTitle = Self.localizedString(for: .verifyItTitle)
    }
}
