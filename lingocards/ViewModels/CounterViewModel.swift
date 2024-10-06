import SwiftUI
import Combine

final class CounterViewModel: ObservableObject {
    // Модель, которую обрабатывает ViewModel
    @Published private var counterModel = CounterModel()
    
    // Публичное свойство, которое наблюдается View (например, Text)
    @Published var displayCount: String = "Count: 0"
    
    init() {
        // Инициализация значения
        updateDisplayCount()
    }
    
    // Метод для увеличения значения счетчика
    func increment() {
        counterModel.count += 1
        updateDisplayCount()
    }
    
    // Обновление текста отображения
    private func updateDisplayCount() {
        displayCount = "Count: \(counterModel.count)"
    }
}
