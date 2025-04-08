import Foundation

final class GameSwipeLocale: ObservableObject {
    private enum LocalizedKey: String {
        case navigationTitle = "screen.gameSwipe.navigationTitle"
        case cardWrong = "screen.gameSwipe.cardWrong"
        case cardRight = "screen.gameSwipe.cardRight"
    }
    
    @Published private(set) var navigationTitle: String
    @Published private(set) var screenCardWrong: String
    @Published private(set) var screenCardRight: String
    
    init() {
        self.navigationTitle = Self.localizedString(for: .navigationTitle)
        self.screenCardWrong = Self.localizedString(for: .cardWrong)
        self.screenCardRight = Self.localizedString(for: .cardRight)
        
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
    
    private static func localizedString(for key: LocalizedKey) -> String {
        return LocaleManager.shared.localizedString(for: key.rawValue)
    }
    
    @objc private func localeDidChange() {
        navigationTitle = Self.localizedString(for: .navigationTitle)
        screenCardWrong = Self.localizedString(for: .cardWrong)
        screenCardRight = Self.localizedString(for: .cardRight)
    }
}
