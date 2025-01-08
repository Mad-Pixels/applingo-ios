import Combine

enum ScreenName: String, Codable {
    case dictionariesLocal
    case dictionariesLocalDetail
    case dictionariesRemote
    case dictionariesRemoteDetail
    case dictionariesRemoteFilter
    case words
    case wordsDetail
    case wordsAdd
    case settings
    case game
}

final class Screen: ObservableObject {
    @Published var activeScreen: ScreenName = .game
    
    static let shared = Screen()
    private var cancellables = Set<AnyCancellable>()

    private init() {
        Logger.debug("[Screen]: Initialized")
    }

    func setActiveScreen(_ screenName: ScreenName) {
        if activeScreen != screenName {
            activeScreen = screenName
            Logger.debug("[Screen]: Activated \(screenName.rawValue)")
        }
    }
    
    func isActive(screenName: ScreenName) -> Bool {
        return activeScreen == screenName
    }

    private func clearErrors(for screenName: ScreenName) {
        //ErrorManager.shared.clearErrors(for: screen)
        Logger.debug("[Screen]: Cleared errors for \(screenName.rawValue)")
    }
}
