import Foundation
import Combine
import SwiftUI

final class SwipeViewModel: ObservableObject {
    @Published private(set) var currentCard: SwipeModelCard?
    @Published private(set) var shouldShowEmptyView = false
    @Published var isProcessingAnswer = false
    @Published var dragOffset = CGSize.zero
    @Published var cardRotation: Double = 0
    
    // Константы для определения жестов
    let swipeThreshold: CGFloat = 100
    let maxRotation: Double = 15
    
    private var cardStartTime: Date?
    private let game: Swipe
    private var loadingTask: Task<Void, Never>?
    private var cancellables = Set<AnyCancellable>()
    
    init(game: Swipe) {
        self.game = game
    }
    
    func generateCard() {
        loadingTask?.cancel()
        currentCard = nil
        shouldShowEmptyView = false
        dragOffset = .zero
        cardRotation = 0
        
        loadingTask = Task { @MainActor in
            for attempt in 1...2 {
                if Task.isCancelled { return }
                
                // Запрашиваем 5 слов (1 главное + 4 для выбора альтернативных backText)
                if let items = game.getItems(5) as? [DatabaseModelWord], !items.isEmpty {
                    let mainWord = items[0]
                    game.removeItem(mainWord)
                    
                    // Создаем новую карточку
                    currentCard = SwipeModelCard(
                        word: mainWord,
                        allWords: items
                    )
                    
                    if let validation = game.validation as? SwipeValidation,
                       let card = currentCard {
                        validation.setCurrentCard(currentCard: card, currentWord: mainWord)
                    }
                    
                    cardStartTime = Date()
                    self.isProcessingAnswer = false
                    return
                }
                
                if attempt < 3 {
                    try? await Task.sleep(nanoseconds: 500_000_000) // 1/2 секунды
                }
            }
            
            shouldShowEmptyView = true
            self.isProcessingAnswer = false
        }
    }
    
    func handleDragGesture(value: DragGesture.Value) {
        // Устанавливаем смещение карточки в соответствии с жестом
        dragOffset = value.translation
        
        // Рассчитываем угол поворота в зависимости от горизонтального смещения
        let dragWidth = value.translation.width
        let rotationAngle = (dragWidth / 300) * maxRotation // 300 - примерная ширина карточки
        cardRotation = rotationAngle
    }
    
    func handleDragEnded(value: DragGesture.Value) {
        let dragThreshold: CGFloat = swipeThreshold
        
        // Если горизонтальное смещение достаточно большое, считаем это свайпом
        if abs(value.translation.width) > dragThreshold {
            // Определяем направление свайпа
            let isSwipeRight = value.translation.width > 0
            
            // Завершаем смещение карточки за пределы экрана
            withAnimation(.spring()) {
                dragOffset = CGSize(
                    width: isSwipeRight ? 1000 : -1000,
                    height: value.translation.height
                )
            }
            
            // Обрабатываем ответ
            processAnswer(isSwipeRight)
        } else {
            // Если свайп недостаточно сильный, возвращаем карточку в исходное положение
            withAnimation(.spring()) {
                dragOffset = .zero
                cardRotation = 0
            }
        }
    }
    
    private func processAnswer(_ isSwipeRight: Bool) {
        guard !isProcessingAnswer, let card = currentCard else { return }
        
        isProcessingAnswer = true
        
        let responseTime = cardStartTime.map { Date().timeIntervalSince($0) } ?? 0
        let result = game.validateAnswer(isSwipeRight)
        
        game.updateStats(
            correct: result == .correct,
            responseTime: responseTime,
            isSpecialCard: false
        )
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.generateCard()
        }
    }
    
    deinit {
        loadingTask?.cancel()
        cancellables.removeAll()
    }
}
