import Foundation

final class GameSwipeLocale: ObservableObject {
    private enum LocalizedKey: String {
        case navigationTitle = "screen.gameSwipe.navigationTitle"
    }
    
    @Published private(set) var navigationTitle: String
    
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
    
    private static func localizedString(for key: LocalizedKey) -> String {
        return LocaleManager.shared.localizedString(for: key.rawValue)
    }
    
    @objc private func localeDidChange() {
        navigationTitle = Self.localizedString(for: .navigationTitle)
    }
}
