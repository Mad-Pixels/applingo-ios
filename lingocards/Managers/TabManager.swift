import Foundation
import Combine

enum Tab: Int, CaseIterable {
    case learn = 0
    case dictionaries = 1
    case words = 2
    case settings = 3
}

final class TabManager: ObservableObject {
    static let shared = TabManager()

    @Published var activeTab: Tab = .learn

    private var cancellables = Set<AnyCancellable>()

    private init() {
        Logger.debug("[TabManager]: Initialized")
    }

    func setActiveTab(_ tab: Tab) {
        DispatchQueue.main.async {
            self.activeTab = tab
            Logger.debug("[TabManager]: setActiveTab called with \(tab)")
        }
    }

    func deactivateTab(_ tab: Tab) {
        if activeTab == tab {
            DispatchQueue.main.async {
                self.activeTab = .learn
                Logger.debug("[TabManager]: deactivateTab called with \(tab)")
            }
        }
    }

    func isActive(tab: Tab) -> Bool {
        return activeTab == tab
    }
}
