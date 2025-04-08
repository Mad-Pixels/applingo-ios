import Foundation

final class HomeLocale: ObservableObject {
    private enum LocalizedKey: String {
        case gameQuiz = "screen.home.game.quiz"
        case gameMatchup = "screen.home.game.matchup"
        case gameSwipe = "screen.home.game.swipe"
    }
    
    @Published private(set) var screenGameQuiz: String
    @Published private(set) var screenGameMatchup: String
    @Published private(set) var screenGameSwipe: String

    init() {
        self.screenGameQuiz = ""
        self.screenGameMatchup = ""
        self.screenGameSwipe = ""
        
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
        screenGameQuiz = Self.localizedString(for: .gameQuiz)
        screenGameMatchup = Self.localizedString(for: .gameMatchup)
        screenGameSwipe = Self.localizedString(for: .gameSwipe)
    }
}
