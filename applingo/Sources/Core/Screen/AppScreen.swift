import Combine

final class AppScreen: ObservableObject {
    @Published var activeScreen: ScreenType = .game
    
    static let shared = AppScreen()
    private var cancellables = Set<AnyCancellable>()

    private init() {
        Logger.debug("[Screen]: Initialized")
    }

    func setActiveScreen(_ screen: ScreenType) {
        if activeScreen != screen {
            activeScreen = screen
            Logger.debug("[Screen]: Activated \(screen.rawValue)")
        }
    }
    
    func isActive(screen: ScreenType) -> Bool {
        return activeScreen == screen
    }

    private func clearErrors(for screen: ScreenType) {
        //ErrorManager.shared.clearErrors(for: screen)
        Logger.debug("[Screen]: Cleared errors for \(screen.rawValue)")
    }
}
