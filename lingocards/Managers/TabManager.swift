import Foundation
import Combine

final class TabManager: ObservableObject {
    @Published var activeTab: AppTab = .learn
    static let shared = TabManager()

    private var cancellables = Set<AnyCancellable>()

    private init() {
        Logger.debug("[TabManager]: Initialized")
    }

    func setActiveTab(_ tab: AppTab) {
        DispatchQueue.main.async {
            self.activeTab = tab
            Logger.debug("[TabManager]: Activate tab \(tab.rawValue)")
        }
    }
    
    func deactivateTab(_ tab: AppTab) {
        if activeTab == tab {
            DispatchQueue.main.async {
                self.activeTab = .learn
                Logger.debug("[TabManager]: Deactivate tab \(tab.rawValue)")
                
                self.clearErrors(for: tab)
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
