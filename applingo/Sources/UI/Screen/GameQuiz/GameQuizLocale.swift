import Foundation

/// Provides localized strings for the GameQuiz view.
final class GameQuizLocale: ObservableObject {
    
    // MARK: - Private Strings
    
    private enum Strings {
        static let learn = "Learn"
    }
    
    // MARK: - Published Properties
    
    /// Navigation title for the quiz.
    @Published private(set) var navigationTitle: String
    
    // MARK: - Initialization
    
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
    
    // MARK: - Localization Helper
    
    private enum LocalizedKey {
        case navigationTitle
        
        var key: String {
            switch self {
            case .navigationTitle: return Strings.learn
            }
        }
        
        var capitalized: Bool {
            // Здесь всегда true, так как название должно быть с заглавной буквы.
            true
        }
    }
    
    private static func localizedString(for key: LocalizedKey) -> String {
        let string = LocaleManager.shared.localizedString(for: key.key)
        return key.capitalized ? string.capitalizedFirstLetter : string
    }
    
    // MARK: - Notification Handler
    
    @objc private func localeDidChange() {
        navigationTitle = Self.localizedString(for: .navigationTitle)
    }
}
