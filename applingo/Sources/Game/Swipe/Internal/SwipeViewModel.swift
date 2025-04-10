import Combine
import SwiftUI

final class SwipeViewModel: ObservableObject {
    @Published private(set) var currentCard: SwipeModelCard?
    @Published private(set) var shouldShowEmptyView = false
    @Published private(set) var isLoadingCard = false
    @Published var highlightedOptions: [String: Color] = [:]
    @Published var isProcessingAnswer = false
    @Published var dragOffset = CGSize.zero
    @Published var cardRotation: Double = 0
    
    @State private var feedbackIcon: (name: String, color: Color)? = nil
    @State private var isFeedbackIconVisible = false
    
    private var cancellables = Set<AnyCancellable>()
    private var loadingTask: Task<Void, Never>?
    private var cardStartTime: Date?
    private let game: Swipe
    
    let swipeThreshold: CGFloat = 100
    let maxRotation: Double = 15
    
    init(game: Swipe) {
        self.game = game
        
        NotificationCenter.default.publisher(for: .visualIconFeedbackShouldUpdate)
            .receive(on: RunLoop.main)
            .sink { [weak self] notification in
                guard let self = self,
                      let userInfo = notification.userInfo,
                      let iconName = userInfo["icon"] as? String,
                      let color = userInfo["color"] as? Color,
                      let duration = userInfo["duration"] as? TimeInterval else {
                    return
                }
                
                self.feedbackIcon = (iconName, color)
                self.isFeedbackIconVisible = true
                
                DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                    self.isFeedbackIconVisible = false
                }
            }
            .store(in: &cancellables)

    }
    
    deinit {
        loadingTask?.cancel()
        cancellables.removeAll()
    }
    
    func generateCard() {
        loadingTask?.cancel()
        
        shouldShowEmptyView = false
        isLoadingCard = true
        currentCard = nil
        dragOffset = .zero
        cardRotation = 0
        
        loadingTask = Task { @MainActor in
            for attempt in 1...3 {
                if Task.isCancelled {
                    return
                }
                
                if let items = game.getItems(2) as? [DatabaseModelWord], !items.isEmpty {
                    let mainWord = items[0]
                    game.removeItem(mainWord)
                    
                    currentCard = SwipeModelCard(
                        word: mainWord,
                        allWords: items
                    )
                    
                    if let validation = game.validation as? SwipeValidation,
                       let card = currentCard {
                        validation.setCurrentCard(currentCard: card, currentWord: mainWord)
                    }
                    
                    self.isProcessingAnswer = false
                    self.isLoadingCard = false
                    cardStartTime = Date()
                    return
                }
                
                if attempt < 3 {
                    try? await Task.sleep(nanoseconds: 800_000_000)
                }
            }
            
            shouldShowEmptyView = true
            self.isProcessingAnswer = false
            self.isLoadingCard = false
        }
    }
    
    func handleDragGesture(value: DragGesture.Value) {
        dragOffset = value.translation
        
        let dragWidth = value.translation.width
        let rotationAngle = (dragWidth / 300) * maxRotation
        cardRotation = rotationAngle
    }
    
    func handleDragEnded(value: DragGesture.Value) {
        let dragThreshold: CGFloat = swipeThreshold
        
        if abs(value.translation.width) > dragThreshold {
            let isSwipeRight = value.translation.width > 0
            
            withAnimation(.spring()) {
                dragOffset = CGSize(
                    width: isSwipeRight ? 1000 : -1000,
                    height: value.translation.height
                )
            }
            processAnswer(isSwipeRight)
        } else {
            withAnimation(.spring()) {
                dragOffset = .zero
                cardRotation = 0
            }
        }
    }
    
    private func processAnswer(_ isSwipeRight: Bool) {
        guard !isProcessingAnswer else { return }
        isProcessingAnswer = true

        let responseTime = cardStartTime.map { Date().timeIntervalSince($0) } ?? 0
        let card = currentCard
        let result = game.validateAnswer(isSwipeRight)
        let bonus = card?.specialBonus

        game.validation.playFeedback(result, answer: "answer", selected: nil)

        game.updateStats(
            correct: result == .correct,
            responseTime: responseTime,
            specialBonus: bonus
        )

        DispatchQueue.main.asyncAfter(deadline: .now() + SWIPE_CORRECT_FEEDBACK_DURATION + 0.1) {
            self.generateCard()
        }
    }
}
