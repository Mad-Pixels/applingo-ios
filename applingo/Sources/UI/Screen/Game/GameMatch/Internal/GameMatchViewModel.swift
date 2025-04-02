import SwiftUI

/// ViewModel для игры Match, которая предлагает пользователю находить соответствующие пары слов.
internal final class MatchGameViewModel: ObservableObject {
    // MARK: - Published свойства
    @Published var frontItems: [DatabaseModelWord] = []  // Слова для левой колонки
    @Published var backItems: [DatabaseModelWord] = []   // Слова для правой колонки
    @Published var selectedFront: DatabaseModelWord?     // Выбранное слово в левой колонке
    @Published var selectedBack: DatabaseModelWord?      // Выбранное слово в правой колонке
    @Published var matchedPairs: Set<Int> = []           // ID отгаданных пар
    
    // MARK: - Константы
    /// Порог совпавших пар, после которого происходит замена слов
    /// Используется в представлении GameMatch для вызова replaceMatchedWords()
    let replaceThreshold = 3
    
    /// Максимальное количество слов, отображаемых одновременно
    let maxWords = 4
    
    // MARK: - Private свойства
    private let game: Match                 // Ссылка на основную игру
    private var selectionStartTime: Date?   // Время начала выбора для измерения скорости ответа
    
    // MARK: - Инициализация
    init(game: Match) {
        self.game = game
    }
    
    // MARK: - Публичные методы
    /// Общий метод выбора карточки в любой колонке
    /// - Parameters:
    ///   - word: Выбранное слово
    ///   - isFromFront: true для левой колонки, false для правой
    func selectItem(_ word: DatabaseModelWord, isFromFront: Bool) {
        // Обрабатываем выбор карточки
        if isFromFront {
            // Если выбрана та же карточка, снимаем выделение
            selectedFront = (selectedFront?.id == word.id) ? nil : word
        } else {
            selectedBack = (selectedBack?.id == word.id) ? nil : word
        }
        
        // Управление таймером
        if selectionStartTime == nil && (selectedFront != nil || selectedBack != nil) {
            // Запускаем таймер при первом выборе
            selectionStartTime = Date()
        } else if selectedFront == nil && selectedBack == nil {
            // Сбрасываем таймер, если отменены все выборы
            selectionStartTime = nil
        }
        
        // Проверяем, есть ли совпадение
        checkMatch()
    }
    
    /// Метод для выбора карточки в левой колонке (для совместимости)
    func selectFront(_ word: DatabaseModelWord) {
        selectItem(word, isFromFront: true)
    }
    
    /// Метод для выбора карточки в правой колонке (для совместимости)
    func selectBack(_ word: DatabaseModelWord) {
        selectItem(word, isFromFront: false)
    }
    
    /// Добавляет новые слова на место отгаданных пар
    /// - Parameter newWords: Массив новых слов для добавления
    func addNewWords(_ newWords: [DatabaseModelWord]) {
        Logger.debug("[MatchViewModel]: Starting addNewWords", metadata: [
            "initialFrontCount": String(frontItems.count),
            "newWordsCount": String(newWords.count)
        ])
        
        // Получаем неотгаданные слова
        let remainingWords = frontItems.filter { !matchedPairs.contains($0.id ?? 0) }
        let needToAdd = maxWords - remainingWords.count
        
        // Если не нужно добавлять новые слова - выходим
        if needToAdd <= 0 {
            Logger.debug("[MatchViewModel]: No need to add new words")
            return
        }
        
        // Создаем эффективные структуры данных для проверок
        let remainingIds = Set(remainingWords.compactMap { $0.id })
        let remainingTexts = Set(remainingWords.flatMap { [$0.frontText, $0.backText] })
        
        // Фильтруем новые слова для избежания дубликатов
        let validNewWords = newWords.filter { word in
            guard let id = word.id, !remainingIds.contains(id) else { return false }
            return !remainingTexts.contains(word.frontText) && !remainingTexts.contains(word.backText)
        }
        
        // Берем только нужное количество слов
        let wordsToAdd = Array(validNewWords.prefix(needToAdd))
        
        Logger.debug("[MatchViewModel]: Words calculation", metadata: [
            "validNewWordsCount": String(validNewWords.count),
            "wordsToAddCount": String(wordsToAdd.count),
            "needToAdd": String(needToAdd)
        ])
        
        // Если не хватает слов для замены, логируем предупреждение
        if wordsToAdd.count < needToAdd {
            Logger.debug("[MatchViewModel]: WARNING - Not enough valid words to add")
        }
        
        // Формируем финальные массивы
        let allWords = remainingWords + wordsToAdd
        
        Logger.debug("[MatchViewModel]: Final arrays preparation", metadata: [
            "totalWords": String(allWords.count),
            "expectedCount": String(maxWords)
        ])
        
        // Обновляем карточки (backItems перемешиваем для разного порядка)
        frontItems = allWords
        backItems = allWords.shuffled()
        
        // Сбрасываем состояние для новой игры
        resetGameState()
        
        Logger.debug("[MatchViewModel]: Final state", metadata: [
            "frontItemsCount": String(frontItems.count),
            "backItemsCount": String(backItems.count)
        ])
    }
    
    /// Настраивает игру, используя предоставленные слова
    /// - Parameter words: Массив слов для игры
    func setupGame(with words: [DatabaseModelWord]) {
        Logger.debug("[MatchViewModel]: Setting up game", metadata: [
            "wordsCount": String(words.count),
            "maxWords": String(maxWords)
        ])
        
        // Берем только нужное количество слов и убеждаемся, что у всех есть id
        let validWords = words.prefix(maxWords).filter { $0.id != nil }
        
        if validWords.count < maxWords {
            Logger.debug("[MatchViewModel]: WARNING - Not enough valid words provided", metadata: [
                "validWordsCount": String(validWords.count),
                "requiredCount": String(maxWords)
            ])
        }
        
        // Создаем две колонки с одинаковыми словами, но в разном порядке
        frontItems = validWords
        backItems = validWords.shuffled()
        
        // Сбрасываем состояние игры
        resetGameState()
        
        Logger.debug("[MatchViewModel]: Game setup complete", metadata: [
            "frontCount": String(frontItems.count),
            "backCount": String(backItems.count)
        ])
    }
    
    // MARK: - Private методы
    /// Проверяет совпадение выбранных карточек
    private func checkMatch() {
        guard let front = selectedFront, let frontId = front.id,
              let back = selectedBack, let backId = back.id else { return }
        
        // Рассчитываем время ответа
        let responseTime = selectionStartTime.map { Date().timeIntervalSince($0) } ?? 0
        
        // Проверка совпадения по ID
        let isCorrect = frontId == backId
        
        // Создаем модель карточки для валидации и фидбека
        if let matchValidation = game.validation as? MatchValidation {
            let cardModel = MatchModelCard(word: front)
            matchValidation.setCurrentCard(currentCard: cardModel, currentWord: front)
            
            // Запускаем фидбек через валидатор
            let result: GameValidationResult = isCorrect ? .correct : .incorrect
            game.validation.playFeedback(result, answer: back.backText)
        }
        
        // Если карточки совпали, добавляем пару в список отгаданных
        if isCorrect {
            matchedPairs.insert(frontId)
        }
        
        // Обновляем статистику игры
        game.updateStats(
            correct: isCorrect,
            responseTime: responseTime,
            isSpecialCard: false
        )
        
        // Сброс выбранных карточек
        selectedFront = nil
        selectedBack = nil
        selectionStartTime = nil
        
        Logger.debug("[MatchViewModel]: Pair checked", metadata: [
            "isMatch": String(isCorrect),
            "responseTime": String(responseTime),
            "matchedPairsCount": String(matchedPairs.count)
        ])
    }
    
    /// Сбрасывает состояние игры, не затрагивая массивы слов
    private func resetGameState() {
        matchedPairs.removeAll()
        selectedFront = nil
        selectedBack = nil
        selectionStartTime = nil
    }
}
