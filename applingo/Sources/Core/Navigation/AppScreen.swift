import Combine

final class AppScreen: ObservableObject {
    @Published var activeScreen: DiscoverScreen = .game
    
    static let shared = AppScreen()
    private var cancellables = Set<AnyCancellable>()

    private init() {
        Logger.debug("[Screen]: Initialized")
    }

    func setActiveScreen(_ screen: DiscoverScreen) {
        if activeScreen != screen {
            activeScreen = screen
            Logger.debug("[Screen]: Activated \(screen.rawValue)")
        }
    }
    
    func isActive(screen: DiscoverScreen) -> Bool {
        return activeScreen == screen
    }

    private func clearErrors(for screen: DiscoverScreen) {
        //ErrorManager.shared.clearErrors(for: screen)
        Logger.debug("[Screen]: Cleared errors for \(screen.rawValue)")
    }
}
