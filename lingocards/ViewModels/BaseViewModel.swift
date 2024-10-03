import SwiftUI
import Combine

enum ActiveAlert: Identifiable {
    case alert(AlertItem)
    case notify(NotifyItem)

    var id: UUID {
        switch self {
        case .alert(let item):
            return item.id
        case .notify(let item):
            return item.id
        }
    }
}

struct AlertItem {
    let id = UUID()
    let title: String
    let message: String
}

struct NotifyItem {
    let id = UUID()
    let title: String
    let message: String
    let primaryAction: () -> Void
    let secondaryAction: (() -> Void)?
}

class BaseViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var activeAlert: ActiveAlert?

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
