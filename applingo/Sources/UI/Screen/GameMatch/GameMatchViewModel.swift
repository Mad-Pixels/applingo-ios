import SwiftUI

/// ViewModel для режима «Match».
final class MatchGameViewModel: ObservableObject {
    @Published var frontItems: [DatabaseModelWord] = []
    @Published var backItems: [DatabaseModelWord] = []
    @Published var score: Int = 0
    @Published var selectedFront: DatabaseModelWord?
    @Published var selectedBack: DatabaseModelWord?
    
    /// Настраивает игру, перемешивая полученные слова для двух колонок.
    func setupGame(with words: [DatabaseModelWord]) {
        Logger.debug("[MatchViewModel]: Setting up game", metadata: [
            "wordsCount": String(words.count)
        ])
        
        frontItems = words.shuffled()
        backItems = words.shuffled()
        
        Logger.debug("[MatchViewModel]: Game setup complete", metadata: [
            "frontCount": String(frontItems.count),
            "backCount": String(backItems.count)
        ])
    }
    
    func selectFront(_ word: DatabaseModelWord) {
        if selectedFront?.id == word.id {
            selectedFront = nil
        } else {
            selectedFront = word
        }
        checkMatch()
    }
    
    func selectBack(_ word: DatabaseModelWord) {
        if selectedBack?.id == word.id {
            selectedBack = nil
        } else {
            selectedBack = word
        }
        checkMatch()
    }
    
    private func checkMatch() {
        guard let front = selectedFront, let back = selectedBack else { return }
        
        // Если идентификаторы совпадают – это правильная пара
        if front.id == back.id {
            score += 1
            frontItems.removeAll { $0.id == front.id }
            backItems.removeAll { $0.id == front.id }
        }
        // Сброс выбора в любом случае
        selectedFront = nil
        selectedBack = nil
    }
}
