import Combine
import SwiftUI

internal final class GameQuizViewModel: ObservableObject {
    @Published var highlightedOptions: [String: Color] = [:]
    @Published private(set) var currentCard: QuizModelCard?
    @Published private(set) var shouldShowEmptyView = false
    @Published private(set) var isLoadingCard = false
    @Published var isProcessingAnswer = false
    
    private var loadingTask: Task<Void, Never>?
    private var cancellables = Set<AnyCancellable>()
    private var cardStartTime: Date?
    private let disableVoice: Bool
    private let game: Quiz
    
    init(game: Quiz) {
        self.disableVoice = AppStorage.shared.noVoice
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
        cancellables.removeAll()
    }
    
    func generateCard() {
        loadingTask?.cancel()

        shouldShowEmptyView = false
        isLoadingCard = true
        currentCard = nil
        
        loadingTask = Task { @MainActor in
            for attempt in 1...3 {
                if Task.isCancelled {
                    return
                }
                
                if let items = game.getItems(4) as? [DatabaseModelWord], !items.isEmpty {
                    let supportSpeaking = self.disableVoice ? false : TTSLanguageType.shared.supported(for: items[0].backTextCode)
                    let correctWord = items[0]
                    game.removeItem(correctWord)
                    
                    var shuffledWords = items
                    shuffledWords.shuffle()
                    
                    currentCard = QuizModelCard(
                        word: correctWord,
                        allWords: shuffledWords,
                        voice: supportSpeaking ? (Double.random(in: 0..<1) < 0.2) : false
                    )
                    
                    if let validation = game.validation as? QuizValidation,
                       let card = currentCard {
                        validation.setCurrentCard(currentCard: card, currentWord: correctWord)
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
    
    func handleAnswer(_ answer: String) {
        guard !isProcessingAnswer else { return }
        
        isProcessingAnswer = true
        
        let responseTime = cardStartTime.map { Date().timeIntervalSince($0) } ?? 0
        let result = game.validateAnswer(answer)
        
        game.validation.playFeedback(result, answer: answer)
        
        game.updateStats(
            correct: result == .correct,
            responseTime: responseTime,
            isSpecialCard: false
        )
        
        if result == .incorrect {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.isLoadingCard = true
                self.generateCard()
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                self.isLoadingCard = true
                self.generateCard()
            }
        }
    }
}
