import SwiftUI
import Combine

class BaseViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var activeAlert: ActiveAlert?
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupSubscriptions()
    }
    
    private func setupSubscriptions() {
        $activeAlert
            .dropFirst()
            .filter { $0 != nil }
            .sink { [weak self] _ in
                self?.isLoading = false
            }
            .store(in: &cancellables)
    }
    
    func showPreloader() {
        isLoading = true
    }
    
    func hidePreloader() {
        isLoading = false
    }
    
    func showAlert(title: String, message: String) {
        activeAlert = .alert(AlertItem(title: title, message: message))
    }
    
    func showNotify(title: String, message: String, primaryAction: @escaping () -> Void, secondaryAction: (() -> Void)? = nil) {
        activeAlert = .notify(NotifyItem(title: title, message: message, primaryAction: primaryAction, secondaryAction: secondaryAction))
    }
}

enum ActiveAlert: Identifiable {
    case alert(AlertItem)
    case notify(NotifyItem)
    
    var id: String {
        switch self {
        case .alert(let alertItem):
            return "alert_\(alertItem.id)"
        case .notify(let notifyItem):
            return "notify_\(notifyItem.id)"
        }
    }
}

struct AlertItem: Identifiable {
    let id = UUID()
    let title: String
    let message: String
}

struct NotifyItem: Identifiable {
    let id = UUID()
    let title: String
    let message: String
    let primaryAction: () -> Void
    let secondaryAction: (() -> Void)?
}
