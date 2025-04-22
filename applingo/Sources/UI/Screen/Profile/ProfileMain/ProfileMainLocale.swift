import Foundation

final class ProfileMainLocale: ObservableObject {
    private enum LocalizedKey: String {
        case title = "screen.profile.title"
        case subtitleLevel = "screen.profile.subtitleLevel"
        case subtitleProgress = "screen.profile.subtitleProgress"
        case textNeedXp = "screen.profile.textNeedXp"
        case textAllXp = "screen.profile.textAllXp"
        
    }
    
    @Published private(set) var screenTitle: String
    @Published private(set) var screenSubtitleLevel: String
    @Published private(set) var screenSubtitleProgress: String
    @Published private(set) var screenTextNeedXp: String
    @Published private(set) var screenTextAllXp: String
    
    init() {
        self.screenTitle = ""
        self.screenSubtitleLevel = ""
        self.screenSubtitleProgress = ""
        self.screenTextNeedXp = ""
        self.screenTextAllXp = ""
    
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
        screenTitle = Self.localizedString(for: .title)
        screenSubtitleLevel = Self.localizedString(for: .subtitleLevel)
        screenSubtitleProgress = Self.localizedString(for: .subtitleProgress)
        screenTextNeedXp = Self.localizedString(for: .textNeedXp)
        screenTextAllXp = Self.localizedString(for: .textAllXp)
    }
}
