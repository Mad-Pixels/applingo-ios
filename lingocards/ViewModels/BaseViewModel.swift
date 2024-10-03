import SwiftUI
import Combine

class BaseViewModel: ObservableObject {
    // Флаг для отображения/скрытия индикатора загрузки
    @Published var isLoading: Bool = false
    // Опциональный элемент для отображения алерта
    @Published var alertItem: AlertItem?
    // Опциональный элемент для отображения уведомления
    @Published var notifyItem: NotifyItem?
    
    // Хранилище для отмены подписок Combine
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupSubscriptions()
    }
    
    // Настройка подписок для автоматического скрытия индикатора загрузки
    private func setupSubscriptions() {
        // Когда появляется алерт, скрываем индикатор загрузки
        $alertItem
            .dropFirst() // Игнорируем начальное значение nil
            .filter { $0 != nil } // Реагируем только на не-nil значения
            .sink { [weak self] _ in
                self?.isLoading = false
            }
            .store(in: &cancellables)
        
        // То же самое для уведомлений
        $notifyItem
            .dropFirst()
            .filter { $0 != nil }
            .sink { [weak self] _ in
                self?.isLoading = false
            }
            .store(in: &cancellables)
    }
    
    // Методы для управления индикатором загрузки
    func showPreloader() {
        isLoading = true
    }
    
    func hidePreloader() {
        isLoading = false
    }
    
    // Метод для отображения алерта
    func showAlert(title: String, message: String) {
        alertItem = AlertItem(title: title, message: message)
    }
    
    // Метод для отображения уведомления с действиями
    func showNotify(title: String, message: String, primaryAction: @escaping () -> Void, secondaryAction: (() -> Void)? = nil) {
        notifyItem = NotifyItem(title: title, message: message, primaryAction: primaryAction, secondaryAction: secondaryAction)
    }
}

// Структура для представления алерта
struct AlertItem: Identifiable {
    let id = UUID()
    let title: String
    let message: String
}

// Структура для представления уведомления с действиями
struct NotifyItem: Identifiable {
    let id = UUID()
    let title: String
    let message: String
    let primaryAction: () -> Void
    let secondaryAction: (() -> Void)?
}
