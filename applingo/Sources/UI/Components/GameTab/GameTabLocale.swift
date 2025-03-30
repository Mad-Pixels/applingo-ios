import Foundation

final class GameTabLocale: ObservableObject {
    private enum LocalizedKey: String {
        case score = "component.GameTab.description.score"
        case streak = "component.GameTab.description.streak"
    }
    
    @Published private(set) var screenScore: String
    @Published private(set) var screenStreak: String
    
    init() {
        self.screenScore = ""
        self.screenStreak = ""
        
        updateLocalizedStrings()
        
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
    
    @objc private func localeDidChange() {
        updateLocalizedStrings()
    }
    
    private static func localizedString(for key: LocalizedKey) -> String {
        return LocaleManager.shared.localizedString(for: key.rawValue)
    }
    
    private func updateLocalizedStrings() {
        screenScore = Self.localizedString(for: .score)
        screenStreak = Self.localizedString(for: .streak)
    }
}
