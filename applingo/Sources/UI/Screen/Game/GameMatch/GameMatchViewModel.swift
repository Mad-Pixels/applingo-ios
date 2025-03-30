import SwiftUI

/// ViewModel для режима «Match».
final class MatchGameViewModel: ObservableObject {
     let maxWords = 8
     let replaceThreshold = 4
    
    @Published var frontItems: [DatabaseModelWord] = []
    @Published var backItems: [DatabaseModelWord] = []
    @Published var selectedFront: DatabaseModelWord?
    @Published var selectedBack: DatabaseModelWord?
    @Published var matchedPairs: Set<Int> = []
    
    private let game: Match  // Добавляем ссылку на игру
    private var selectionStartTime: Date?  // Для измерения времени ответа
    
    init(game: Match) {
        self.game = game
    }
    
    func selectFront(_ word: DatabaseModelWord) {
        if selectedFront?.id == word.id {
            selectedFront = nil
            selectionStartTime = nil
        } else {
            selectedFront = word
            if selectionStartTime == nil {
                selectionStartTime = Date()
            }
        }
        checkMatch()
    }
    
    func selectBack(_ word: DatabaseModelWord) {
        if selectedBack?.id == word.id {
            selectedBack = nil
            selectionStartTime = nil
        } else {
            selectedBack = word
            if selectionStartTime == nil {
                selectionStartTime = Date()
            }
        }
        checkMatch()
    }
    
    private func checkMatch() {
        guard let front = selectedFront,
              let back = selectedBack,
              let frontId = front.id,
              let backId = back.id
        else { return }
        
        // Рассчитываем время ответа
        let responseTime = selectionStartTime.map { Date().timeIntervalSince($0) } ?? 0
        
        // Проверяем совпадение
        let isCorrect = frontId == backId
        if isCorrect {
            matchedPairs.insert(frontId)
        }
        
        // Обновляем статистику
        game.updateStats(
            correct: isCorrect,
            responseTime: responseTime,
            isSpecialCard: false
        )
        
        // Сброс состояния
        selectedFront = nil
        selectedBack = nil
        selectionStartTime = nil
        
        Logger.debug("[MatchViewModel]: Pair checked", metadata: [
            "isMatch": String(isCorrect),
            "responseTime": String(responseTime),
            "matchedPairsCount": String(matchedPairs.count)
        ])
    }
    
    /// Добавляет новые слова на место отгаданных
    func addNewWords(_ newWords: [DatabaseModelWord]) {
        Logger.debug("[MatchViewModel]: Starting addNewWords", metadata: [
            "initialFrontCount": String(frontItems.count),
            "initialBackCount": String(backItems.count),
            "newWordsProvidedCount": String(newWords.count),
            "maxWords": String(maxWords)
        ])
        
        // Получаем индексы отгаданных слов
        let matchedIndices = frontItems.enumerated()
            .filter { matchedPairs.contains($0.element.id ?? 0) }
            .map { $0.offset }
        
        // Получаем неотгаданные слова
        let remainingWords = frontItems.filter { !matchedPairs.contains($0.id ?? 0) }
        
        Logger.debug("[MatchViewModel]: Current state", metadata: [
            "matchedIndicesCount": String(matchedIndices.count),
            "remainingWordsCount": String(remainingWords.count)
        ])
        
        // Фильтруем новые слова на наличие дубликатов с оставшимися словами
        let validNewWords = newWords.filter { newWord in
            !remainingWords.contains { existing in
                existing.frontText == newWord.frontText ||
                existing.frontText == newWord.backText ||
                existing.backText == newWord.frontText ||
                existing.backText == newWord.backText
            }
        }
        
        // Сколько слов нам нужно добавить
        let needToAdd = maxWords - remainingWords.count
        
        Logger.debug("[MatchViewModel]: Words calculation", metadata: [
            "validNewWordsCount": String(validNewWords.count),
            "needToAdd": String(needToAdd)
        ])
        
        // Берем только нужное количество валидных новых слов
        let wordsToAdd = Array(validNewWords.prefix(needToAdd))
        
        // Формируем финальные массивы
        let allWords = remainingWords + wordsToAdd
        
        Logger.debug("[MatchViewModel]: Final arrays preparation", metadata: [
            "remainingWords": String(remainingWords.count),
            "wordsToAdd": String(wordsToAdd.count),
            "totalWords": String(allWords.count)
        ])
        
        if allWords.count != maxWords {
            Logger.debug("[MatchViewModel]: WARNING - Wrong word count!", metadata: [
                "actualCount": String(allWords.count),
                "expectedCount": String(maxWords)
            ])
        }
        
        // Проверяем на дубликаты в финальном наборе
        let hasDuplicates = Set(allWords.map { $0.id }).count != allWords.count
        if hasDuplicates {
            Logger.debug("[MatchViewModel]: ERROR - Duplicates detected in final array!")
        }
        
        frontItems = allWords
        // Для правой колонки перемешиваем те же слова
        backItems = allWords.shuffled()
        
        matchedPairs.removeAll()
        selectionStartTime = nil
        
        Logger.debug("[MatchViewModel]: Final state", metadata: [
            "frontItemsCount": String(frontItems.count),
            "backItemsCount": String(backItems.count),
            "hasDuplicates": String(hasDuplicates)
        ])
    }
    
    /// Настраивает игру, перемешивая полученные слова для двух колонок
    func setupGame(with words: [DatabaseModelWord]) {
            Logger.debug("[MatchViewModel]: Setting up game", metadata: [
                "wordsCount": String(words.count),
                "maxWords": String(maxWords)
            ])
            
            // Берем только нужное количество слов
            let initialWords = Array(words.prefix(maxWords))
            
            frontItems = initialWords.shuffled()
            backItems = initialWords.shuffled()
            matchedPairs.removeAll()
            selectedFront = nil
            selectedBack = nil
            selectionStartTime = nil
            
            Logger.debug("[MatchViewModel]: Game setup complete", metadata: [
                "frontCount": String(frontItems.count),
                "backCount": String(backItems.count)
            ])
        }
}
