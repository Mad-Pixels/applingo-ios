import Foundation

final class DictionarySendLocale: ObservableObject {
    private enum LocalizedKey: String {
        case title = "screen.dictionarySend.title"
        case description = "screen.dictionarySend.description"
        case buttonEnable = "screen.dictionarySend.buttonEnable"
    }

    @Published private(set) var screenTitle: String = ""
    @Published private(set) var screenDescription: String = ""
    @Published private(set) var screenButtonEnable: String = ""

    init() {
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

    private func updateLocalizedStrings() {
        screenTitle = localized(.title)
        screenDescription = localized(.description)
        screenButtonEnable = localized(.buttonEnable)
    }

    private func localized(_ key: LocalizedKey) -> String {
        LocaleManager.shared.localizedString(for: key.rawValue)
    }
}
