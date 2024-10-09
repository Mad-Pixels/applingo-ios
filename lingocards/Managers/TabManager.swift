import Foundation
import Combine

final class TabManager: ObservableObject {
    static let shared = TabManager()
    
    @Published var activeTab: AppTab = .learn

    private var cancellables = Set<AnyCancellable>()

    private init() {
        Logger.debug("[TabManager]: Initialized")
    }

    func setActiveTab(_ tab: AppTab) {
        //guard self.activeTab != tab else { return }
        DispatchQueue.main.async {
            self.activeTab = tab
            Logger.debug("[TabManager]: setActiveTab called with \(tab.rawValue)")
        }
    }
    
    func deactivateTab(_ tab: AppTab) {
        if activeTab == tab {
            DispatchQueue.main.async {
                self.activeTab = .learn
                Logger.debug("[TabManager]: deactivateTab called with \(tab.rawValue)")
                
                //self.clearErrors(for: tab)
            }
        }
    }
    
    func isActive(tab: AppTab) -> Bool {
        return activeTab == tab
    }

    private func clearErrors(for tab: AppTab) {
        ErrorManager.shared.clearErrors(for: tab)
        Logger.debug("[TabManager]: Cleared errors for \(tab.rawValue)")
    }
}
