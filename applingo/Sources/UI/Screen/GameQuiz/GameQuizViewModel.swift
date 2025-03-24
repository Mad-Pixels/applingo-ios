import Foundation
import Combine
import SwiftUI

final class QuizViewModel: ObservableObject {
    @Published private(set) var currentCard: QuizModelCard?
    @Published private(set) var shouldShowEmptyView = false
    @Published var highlightedOptions: [String: Color] = [:]
    // Добавляем переменную для блокировки интерфейса
    @Published var isProcessingAnswer = false
    
    private var cardStartTime: Date?
    private let game: Quiz
    private var loadingTask: Task<Void, Never>?
    private var cancellables = Set<AnyCancellable>()
    
    init(game: Quiz) {
        self.game = game
        
        // Подписываемся на уведомления о визуальной обратной связи
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
                
                // Устанавливаем цвет для опции
                self.highlightedOptions[option] = color
                
                // Сбрасываем выделение через указанное время
                DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                    self.highlightedOptions.removeValue(forKey: option)
                }
            }
            .store(in: &cancellables)
    }
    
    func generateCard() {
        // Существующий код...
        loadingTask?.cancel()
        currentCard = nil
        shouldShowEmptyView = false
        
        loadingTask = Task { @MainActor in
            // Существующий код...
            for attempt in 1...2 {
                if Task.isCancelled { return }
                
                if let items = game.getItems(4) as? [DatabaseModelWord] {
                    let correctWord = items[0]
                    game.removeItem(correctWord)
                    
                    var shuffledWords = items
                    shuffledWords.shuffle()
                    
                    currentCard = QuizModelCard(
                        word: correctWord,
                        allWords: shuffledWords,
                        showingFront: Bool.random()
                    )
                    
                    if let validation = game.validation as? QuizValidation,
                       let card = currentCard {
                        validation.setCurrentCard(currentCard: card, currentWord: correctWord)
                    }
                    
                    cardStartTime = Date()
                    // Разблокируем интерфейс после генерации новой карточки
                    self.isProcessingAnswer = false
                    return
                }
                
                if attempt < 3 {
                    try? await Task.sleep(nanoseconds: 500_000_000) // 1/2 секунды
                }
            }
            
            shouldShowEmptyView = true
            // Разблокируем интерфейс если нет карточек
            self.isProcessingAnswer = false
        }
    }
    
    func handleAnswer(_ answer: String) {
        // Проверяем, не обрабатывается ли уже ответ
        guard !isProcessingAnswer else { return }
        
        // Блокируем интерфейс на время обработки ответа
        isProcessingAnswer = true
        
        let responseTime = cardStartTime.map { Date().timeIntervalSince($0) } ?? 0
        let result = game.validateAnswer(answer)
        
        // Передаем выбранный ответ в метод playFeedback
        game.validation.playFeedback(result, answer: answer)
        
        game.updateStats(
            correct: result == .correct,
            responseTime: responseTime,
            isSpecialCard: false
        )
        
        // Если неправильный ответ, добавляем задержку перед следующей карточкой
        if result == .incorrect {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                self.generateCard()
            }
        } else {
            generateCard()
        }
    }
    
    deinit {
        loadingTask?.cancel()
        cancellables.removeAll()
    }
}
