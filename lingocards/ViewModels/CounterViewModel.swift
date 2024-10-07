import SwiftUI
import Combine

final class CounterViewModel: ObservableObject {
    
    // Публичное свойство, которое наблюдается View (например, Text)
    @Published var displayCount: String = "Count: 0"
    
    init() {
        // Инициализация значения
       
    }
}
