import SwiftUI

/// ViewModel для режима «Match».
final class MatchGameViewModel: ObservableObject {
    /// Массив слов для левой колонки (frontText)
    @Published var frontItems: [DatabaseModelWord] = []
    /// Массив слов для правой колонки (backText)
    @Published var backItems: [DatabaseModelWord] = []
    /// Выбранный элемент из левой колонки.
    @Published var selectedFront: DatabaseModelWord?
    /// Выбранный элемент из правой колонки.
    @Published var selectedBack: DatabaseModelWord?
    /// Текущий счёт.
    @Published var score: Int = 0
    
    /// Настраивает игру, принимая 8 слов и перемешивая их независимо для двух колонок.
    func setupGame(with words: [DatabaseModelWord]) {
        // Ожидается, что words содержит ровно 8 элементов
        frontItems = words.shuffled()
        backItems = words.shuffled()
    }
    
    /// Обработка выбора слова из левой колонки.
    func selectFront(_ word: DatabaseModelWord) {
        if selectedFront?.id == word.id {
            selectedFront = nil
        } else {
            selectedFront = word
        }
        checkMatch()
    }
    
    /// Обработка выбора слова из правой колонки.
    func selectBack(_ word: DatabaseModelWord) {
        if selectedBack?.id == word.id {
            selectedBack = nil
        } else {
            selectedBack = word
        }
        checkMatch()
    }
    
    /// Проверка совпадения выбранных элементов.
    private func checkMatch() {
        guard let front = selectedFront, let back = selectedBack else { return }
        
        // Если id совпадают, значит это правильная пара
        if front.id == back.id {
            score += 1
            frontItems.removeAll { $0.id == front.id }
            backItems.removeAll { $0.id == front.id }
        }
        // Сбрасываем выбор независимо от результата
        selectedFront = nil
        selectedBack = nil
    }
}
