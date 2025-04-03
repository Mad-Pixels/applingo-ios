import SwiftUI
import Combine

internal final class GameMatchViewModel: ObservableObject {
    @Published var highlightedOptions: [String: Color] = [:]
    @Published private(set) var currentCards: [MatchModelCard] = []
    @Published private(set) var shouldShowEmptyView = false
    @Published private(set) var isLoadingCard = false

    @Published var matchedIndices: Set<Int> = []
    @Published var selectedFrontIndex: Int?
    @Published var selectedBackIndex: Int?

    @Published var leftOrder: [Int] = []
    @Published var rightOrder: [Int] = []
    
    // Отслеживаем карточки, которые в данный момент обновляются
    @Published private var updatingCardIndices: Set<Int> = []

    private var loadingTask: Task<Void, Never>?
    private var cancellables = Set<AnyCancellable>()
    private var cardStartTime: Date?
    private let game: Match

    // Уменьшаем порог замены до 2
    let replaceThreshold = 2
    let maxCards = 6
    
    // Задержки обновления карточек
    private var updateTasks: [Int: Task<Void, Never>] = [:]

    init(game: Match) {
        self.game = game

        NotificationCenter.default.publisher(for: .visualFeedbackShouldUpdate)
            .receive(on: RunLoop.main)
            .sink { [weak self] notification in
                guard let self = self,
                      let userInfo = notification.userInfo,
                      let option = userInfo["option"] as? String,
                      let color = userInfo["color"] as? Color,
                      let duration = userInfo["duration"] as? TimeInterval else {
                    return
                }
                self.highlightedOptions[option] = color
                DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                    self.highlightedOptions.removeValue(forKey: option)
                }
            }
            .store(in: &cancellables)
    }

    deinit {
        loadingTask?.cancel()
        updateTasks.values.forEach { $0.cancel() }
        cancellables.removeAll()
    }
    
    // Публичный метод для проверки, обновляется ли карточка
    func isCardUpdating(index: Int) -> Bool {
        return updatingCardIndices.contains(index)
    }

    func generateCards() {
        loadingTask?.cancel()
        shouldShowEmptyView = false
        isLoadingCard = true
        currentCards = []

        loadingTask = Task { @MainActor in
            for attempt in 1...3 {
                if Task.isCancelled { return }
                if let items = game.getItems(maxCards) as? [DatabaseModelWord], !items.isEmpty {
                    let words = items.prefix(maxCards).filter { $0.id != nil }
                    currentCards = words.map { MatchModelCard(word: $0) }
                    
                    leftOrder = Array(0..<currentCards.count).shuffled()
                    rightOrder = Array(0..<currentCards.count).shuffled()
                    isLoadingCard = false
                    cardStartTime = Date()
                    resetGameState()
                    return
                }
                if attempt < 3 {
                    try? await Task.sleep(nanoseconds: 800_000_000)
                }
            }
            shouldShowEmptyView = true
            isLoadingCard = false
        }
    }

    func updateMatchedCards() {
        let matchedIndicesArray = Array(matchedIndices)
        guard !matchedIndicesArray.isEmpty else { return }

        // Удаляем угаданные слова из игры
        for cardIndex in matchedIndicesArray {
            let guessedWord = currentCards[cardIndex].word
            game.removeItem(guessedWord)
            
            // Помечаем карточку как обновляющуюся
            updatingCardIndices.insert(cardIndex)
        }

        // Получаем новые слова для замены
        guard let newItems = game.getItems(matchedIndicesArray.count) as? [DatabaseModelWord],
              !newItems.isEmpty else { return }
              
        let words = newItems.prefix(matchedIndicesArray.count).filter { $0.id != nil }

        // Заменяем слова в карточках с задержками
        for (i, cardIndex) in matchedIndicesArray.enumerated() {
            if i < words.count {
                // Отменяем предыдущую задачу для этой карточки, если она существует
                updateTasks[cardIndex]?.cancel()
                
                let newWord = words[i]
                let updateTask = Task { @MainActor in
                    // Добавляем случайную задержку для каждой карточки
                    let randomDelay = Double.random(in: 0.3...1.0)
                    try? await Task.sleep(nanoseconds: UInt64(randomDelay * 1_000_000_000))
                    
                    // Обновляем карточку
                    if !Task.isCancelled {
                        currentCards[cardIndex] = MatchModelCard(word: newWord)
                        updatingCardIndices.remove(cardIndex)
                    }
                }
                
                updateTasks[cardIndex] = updateTask
            }
        }
        
        // Обновляем порядок карточек - ОРИГИНАЛЬНЫЙ КОД
        updateOrder(&leftOrder)
        updateOrder(&rightOrder)

        // Очищаем список отгаданных карточек
        matchedIndices.removeAll()
    }
    
    // ОРИГИНАЛЬНЫЙ метод для обновления порядка - НЕ ИЗМЕНЕН
    private func updateOrder(_ order: inout [Int]) {
        var freePositions: [Int] = []
        var freeCardIndices: [Int] = []
        for (pos, cardIndex) in order.enumerated() {
            if updatingCardIndices.contains(cardIndex) {
                freePositions.append(pos)
                freeCardIndices.append(cardIndex)
            }
        }
        freeCardIndices.shuffle()
        for (i, pos) in freePositions.enumerated() {
            order[pos] = freeCardIndices[i]
        }
    }

    func selectFront(at index: Int) {
        guard index >= 0, index < currentCards.count, !isCardUpdating(index: index) else { return }
        selectedFrontIndex = (selectedFrontIndex == index) ? nil : index

        if cardStartTime == nil && (selectedFrontIndex != nil || selectedBackIndex != nil) {
            cardStartTime = Date()
        } else if selectedFrontIndex == nil && selectedBackIndex == nil {
            cardStartTime = nil
        }
        checkMatch()
    }

    func selectBack(at index: Int) {
        guard index >= 0, index < currentCards.count, !isCardUpdating(index: index) else { return }
        selectedBackIndex = (selectedBackIndex == index) ? nil : index

        if cardStartTime == nil && (selectedFrontIndex != nil || selectedBackIndex != nil) {
            cardStartTime = Date()
        } else if selectedFrontIndex == nil && selectedBackIndex == nil {
            cardStartTime = nil
        }
        checkMatch()
    }

    private func checkMatch() {
        guard let frontIndex = selectedFrontIndex,
              let backIndex = selectedBackIndex,
              frontIndex >= 0, frontIndex < currentCards.count,
              backIndex >= 0, backIndex < currentCards.count else {
            return
        }

        let responseTime = cardStartTime.map { Date().timeIntervalSince($0) } ?? 0
        let isCorrect = currentCards[frontIndex].word.id == currentCards[backIndex].word.id

        if let matchValidation = game.validation as? MatchValidation {
            let card = currentCards[frontIndex]
            matchValidation.setCurrentCard(currentCard: card, currentWord: card.word)
            let result: GameValidationResult = isCorrect ? .correct : .incorrect
            game.validation.playFeedback(
                result,
                answer: currentCards[backIndex].answer,
                selected: currentCards[frontIndex].question
            )
            game.updateStats(
                correct: isCorrect,
                responseTime: responseTime,
                isSpecialCard: false
            )
        }

        if isCorrect {
            matchedIndices.insert(frontIndex)
            matchedIndices.insert(backIndex)

            if matchedIndices.count >= replaceThreshold {
                updateMatchedCards()
            }
        }

        selectedFrontIndex = nil
        selectedBackIndex = nil
        cardStartTime = nil
    }

    private func resetGameState() {
        highlightedOptions.removeAll()
        matchedIndices.removeAll()
        updatingCardIndices.removeAll()
        updateTasks.values.forEach { $0.cancel() }
        updateTasks.removeAll()
        selectedFrontIndex = nil
        selectedBackIndex = nil
        cardStartTime = nil
    }
}
