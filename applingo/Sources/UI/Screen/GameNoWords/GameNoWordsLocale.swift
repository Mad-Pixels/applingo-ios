import Foundation

/// Provides localized strings for the GameNoWords view.
final class GameNoWordsLocale: ObservableObject {
    
    // MARK: - Localized Keys
    private enum LocalizedKey: String {
        case subtitle = "screen.noWords.subtitle"
        case text = "screen.noWords.text"
    }
    
    // MARK: - Published Properties
    @Published private(set) var screenSubtitleNoWords: String
    @Published private(set) var screenTextNoWords: String
    
    // MARK: - Initialization
    init() {
        self.screenSubtitleNoWords = Self.localizedString(for: .subtitle)
        self.screenTextNoWords = Self.localizedString(for: .text)
        
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
        screenSubtitleNoWords = Self.localizedString(for: .subtitle)
        screenTextNoWords = Self.localizedString(for: .text)
    }
}
