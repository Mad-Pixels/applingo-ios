import SwiftUI
import Combine

/// Базовый класс ViewModel, предоставляющий общую функциональность для управления состоянием загрузки и отображения алертов/уведомлений
class BaseViewModel: ObservableObject {
    /// Флаг, указывающий, выполняется ли в данный момент загрузка
    @Published var isLoading: Bool = false
    /// Активный алерт или уведомление для отображения
    @Published var activeAlert: ActiveAlert?
    
    /// Хранилище для отмены подписок Combine
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupSubscriptions()
    }
    
    /// Настройка подписок для автоматического скрытия индикатора загрузки при появлении алерта/уведомления
    private func setupSubscriptions() {
        $activeAlert
            .dropFirst() // Игнорируем начальное значение nil
            .filter { $0 != nil } // Реагируем только на не-nil значения
            .sink { [weak self] _ in
                self?.isLoading = false // Скрываем индикатор загрузки при появлении алерта/уведомления
            }
            .store(in: &cancellables)
    }
    
    /// Показать индикатор загрузки
    func showPreloader() {
        isLoading = true
    }
    
    /// Скрыть индикатор загрузки
    func hidePreloader() {
        isLoading = false
    }
    
    /// Показать алерт с заданным заголовком и сообщением
    /// - Parameters:
    ///   - title: Заголовок алерта
    ///   - message: Сообщение алерта
    func showAlert(title: String, message: String) {
        activeAlert = .alert(AlertItem(title: title, message: message))
    }
    
    /// Показать уведомление с заданным заголовком, сообщением и действиями
    /// - Parameters:
    ///   - title: Заголовок уведомления
    ///   - message: Сообщение уведомления
    ///   - primaryAction: Основное действие (кнопка OK)
    ///   - secondaryAction: Дополнительное действие (кнопка Cancel), опционально
    func showNotify(title: String, message: String, primaryAction: @escaping () -> Void, secondaryAction: (() -> Void)? = nil) {
        activeAlert = .notify(NotifyItem(title: title, message: message, primaryAction: primaryAction, secondaryAction: secondaryAction))
    }
}

/// Перечисление, представляющее тип активного алерта/уведомления
enum ActiveAlert: Identifiable {
    case alert(AlertItem)
    case notify(NotifyItem)
    
    /// Уникальный идентификатор для каждого случая ActiveAlert
    var id: String {
        switch self {
        case .alert(let alertItem):
            return "alert_\(alertItem.id)"
        case .notify(let notifyItem):
            return "notify_\(notifyItem.id)"
        }
    }
}

/// Структура, представляющая простой алерт
struct AlertItem: Identifiable {
    let id = UUID()
    let title: String
    let message: String
}

/// Структура, представляющая уведомление с действиями
struct NotifyItem: Identifiable {
    let id = UUID()
    let title: String
    let message: String
    let primaryAction: () -> Void
    let secondaryAction: (() -> Void)?
}
