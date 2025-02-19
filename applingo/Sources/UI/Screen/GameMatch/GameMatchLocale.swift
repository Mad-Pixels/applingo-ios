import Foundation

/// Provides localized strings for the GameQuiz view.
final class GameMatchLocale: ObservableObject {
    // MARK: - Localized Keys
    private enum LocalizedKey: String {
        case navigationTitle = "screen.gameMatch.navigationTitle"
    }
    
    // MARK: - Published Properties
    /// The navigation title for the quiz.
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
    /// Returns a localized string for the specified key.
    ///
    /// - Parameter key: A value from the `LocalizedKey` enum.
    /// - Returns: The localized string corresponding to the provided key.
    private static func localizedString(for key: LocalizedKey) -> String {
        return LocaleManager.shared.localizedString(for: key.rawValue)
    }
    
    // MARK: - Notification Handler
    /// Handles locale change notifications by updating the navigation title.
    @objc private func localeDidChange() {
        navigationTitle = Self.localizedString(for: .navigationTitle)
    }
}
