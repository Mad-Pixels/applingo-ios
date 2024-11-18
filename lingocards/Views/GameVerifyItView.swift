import SwiftUI

struct GameVerifyItView: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        BaseGameView(isPresented: $isPresented) {
            GameVerifyItContent()
        }
    }
}

private struct GameVerifyItContent: View {
    @EnvironmentObject var cacheGetter: GameCacheGetterViewModel
    @EnvironmentObject var gameAction: GameActionViewModel
    
    @State private var currentCard: GameVerifyCardModel?
    @State private var showAnswerFeedback = false
    @State private var cardOffset: CGFloat = 0
    @State private var cardRotation: Double = 0
    @State private var startTime: TimeInterval = 0
    @State private var hintPenalty: Int = 0
    @State private var showSuccessEffect = false
    @State private var hintState = GameHintState(isShowing: false, wasUsed: false)
    
    var body: some View {
        ZStack {
            if cacheGetter.isLoadingCache {
                CompPreloaderView()
            } else {
                if let card = currentCard {
                    CompGameCardSwipeView(
                        card: card,
                        offset: cardOffset,
                        rotation: cardRotation,
                        onSwipe: { isRight in
                            handleSwipe(isRight: isRight)
                        },
                        onHintUsed: {
                            hintPenalty = 5
                        },
                        specialService: gameAction.specialServiceProvider,
                        hintState: $hintState
                    )
                }
                if showAnswerFeedback {
                    answerFeedbackView.zIndex(1)
                }
            }
        }
        .onAppear { setupGame() }
        .onChange(of: cacheGetter.isLoadingCache) { isLoading in
            if !isLoading { setupGame() }
        }
    }
    
    private var answerFeedbackView: some View {
        VStack {
            if let card = currentCard,
               card.isSpecial && gameAction.stats.isLastAnswerCorrect {
                Image(systemName: "star.circle.fill")
                    .foregroundColor(.yellow)
                    .font(.system(size: 80))
                    .transition(.scale.combined(with: .opacity))
            } else {
                Image(systemName: gameAction.stats.isLastAnswerCorrect ? "checkmark.circle.fill" : "x.circle.fill")
                    .foregroundColor(gameAction.stats.isLastAnswerCorrect ? .green : .red)
                    .font(.system(size: 60))
            }
        }
    }
    
    private func setupGame() {
        let special = SpecialGoldCard(
            config: .standard,
            showSuccessEffect: $showSuccessEffect
        )
        gameAction.registerSpecial(special)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            if cacheGetter.cache.count >= 8 {
                generateNewCard()
            }
        }
    }
    
    private func generateNewCard() {
        guard cacheGetter.cache.count >= 8 else { return }
        
        let shouldUseSameWord = Bool.random()
        let firstWord = cacheGetter.cache.randomElement()!
        let secondWord = shouldUseSameWord ? firstWord : cacheGetter.cache.filter { $0.id != firstWord.id }.randomElement()!
        
        hintState = GameHintState(isShowing: false, wasUsed: false)
        startTime = Date().timeIntervalSince1970
        hintPenalty = 0
        
        withAnimation {
            currentCard = GameVerifyCardModel(
                frontWord: firstWord,
                backText: secondWord.backText,
                isMatch: shouldUseSameWord,
                isSpecial: gameAction.isSpecial(firstWord)
            )
            cardOffset = 0
            cardRotation = 0
        }
    }
    
    private func handleSwipe(isRight: Bool) {
        guard let card = currentCard else { return }
        
        let responseTime = Date().timeIntervalSince1970 - startTime
        let isCorrect = isRight == card.isMatch
        let result = GameVerifyResultModel(
            word: card.frontWord,
            isCorrect: isCorrect,
            responseTime: responseTime,
            isSpecial: card.isSpecial,
            hintPenalty: hintPenalty
        )
        gameAction.handleGameResult(result)
        
        if !isCorrect {
            FeedbackWrongAnswerHaptic().playHaptic()
        }
        
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            showAnswerFeedback = true
            cardOffset = isRight ? 1000 : -1000
            cardRotation = isRight ? 20 : -20
        }
        cacheGetter.removeFromCache(card.frontWord)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation {
                showAnswerFeedback = false
                currentCard = nil
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                generateNewCard()
            }
        }
    }
}
