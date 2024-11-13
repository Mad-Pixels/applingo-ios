import SwiftUI

struct GameVerifyItView: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        BaseGameView(isPresented: $isPresented) {
            GameVerifyItContent()
        }
    }
}

struct GameVerifyItContent: View {
    @EnvironmentObject var cacheGetter: GameCacheGetterViewModel
    @EnvironmentObject var gameHandler: GameHandler
    @EnvironmentObject var specialService: GameSpecialService
    @Environment(\.showScore) private var showScore
    
    @State private var currentCard: VerifyCardModel?
    @State private var showAnswerFeedback = false
    @State private var cardOffset: CGFloat = 0
    @State private var cardRotation: Double = 0
    @State private var startTime: TimeInterval = 0
    @State private var hintPenalty: Int = 0
    @State private var isErrorBorderActive = false
    @State private var showSuccessEffect = false
    
    @StateObject private var feedbackHandler = GameFeedback.wrongAnswer(
        isActive: .constant(false)
    )
    
    var body: some View {
        ZStack {
            if cacheGetter.isLoadingCache {
                CompPreloaderView()
            } else {
                if let card = currentCard {
                    CardView(
                        card: card,
                        offset: cardOffset,
                        rotation: cardRotation,
                        onSwipe: { isRight in
                            handleSwipe(isRight: isRight)
                        },
                        onHintUsed: {
                            hintPenalty = 5
                        }
                    )
                    .withFeedback(FeedbackErrorBorder(
                        isActive: $isErrorBorderActive,
                        duration: 0.5
                    ))
                }
                
                if showAnswerFeedback {
                    answerFeedbackView
                        .zIndex(1)
                }
            }
        }
        .onAppear(perform: setupGame)
        .onDisappear(perform: cleanupGame)
    }
    
    private var answerFeedbackView: some View {
        VStack {
            if let card = currentCard,
               card.isSpecial && gameHandler.stats.isLastAnswerCorrect {
                Image(systemName: "star.circle.fill")
                    .foregroundColor(.yellow)
                    .font(.system(size: 80))
                    .transition(.scale.combined(with: .opacity))
            } else {
                Image(systemName: gameHandler.stats.isLastAnswerCorrect ?
                      "checkmark.circle.fill" : "x.circle.fill")
                    .foregroundColor(gameHandler.stats.isLastAnswerCorrect ?
                                   .green : .red)
                    .font(.system(size: 60))
            }
        }
    }
    
    private func setupGame() {
        specialService.withSpecial(
            SpecialGoldCard(
                config: .standard,
                showSuccessEffect: $showSuccessEffect
            )
        )
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            if cacheGetter.cache.count >= 8 {
                generateNewCard()
            }
        }
    }
    
    private func cleanupGame() {
        specialService.clear()
    }
    
    private func generateNewCard() {
        guard cacheGetter.cache.count >= 8 else { return }
        
        let shouldUseSameWord = Bool.random()
        let firstWord = cacheGetter.cache.randomElement()!
        let secondWord = shouldUseSameWord ? firstWord : cacheGetter.cache.filter {
            $0.id != firstWord.id
        }.randomElement()!
        
        startTime = Date().timeIntervalSince1970
        withAnimation {
            currentCard = VerifyCardModel(
                frontWord: firstWord,
                backText: secondWord.backText,
                isMatch: shouldUseSameWord,
                isSpecial: specialService.isSpecial(firstWord)
            )
            cardOffset = 0
            cardRotation = 0
        }
    }
    
    private func handleSwipe(isRight: Bool) {
        guard let card = currentCard else { return }
        
        let result = VerifyGameResultModel(
            word: card.frontWord,
            isCorrect: isRight == card.isMatch,
            responseTime: Date().timeIntervalSince1970 - startTime,
            isSpecial: card.isSpecial,
            hintPenalty: hintPenalty
        )
        
        gameHandler.handleResult(result)
        
        if let scoreResult = gameHandler.stats.lastScoreResult {
            showScore?(scoreResult.total, scoreResult.reason)
        }
        
        if !result.isCorrect {
            isErrorBorderActive = true
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


struct CardView: View {
    let card: VerifyCardModel
    let offset: CGFloat
    let rotation: Double
    let onSwipe: (Bool) -> Void
    let onHintUsed: () -> Void
    
    @GestureState private var dragState = DragStateModel.inactive
    @State private var swipeStatus: SwipeStatusModel = .none
    @State private var showSuccessEffect: Bool = false
    @State private var showHint: Bool = false
    @State private var hintWasUsed: Bool = false
    
    @Environment(\.specialService) private var specialService
    
    private var cardRotation: Double {
        let dragRotation = Double(dragState.translation.width / 300) * 20
        let totalRotation = rotation + dragRotation
        return min(max(totalRotation, -45), 45)
    }
    
    private var dragPercentage: Double {
        let maxDistance: CGFloat = UIScreen.main.bounds.width / 2
        let percentage = abs(dragState.translation.width) / maxDistance
        return min(max(Double(percentage), 0.0), 1.0)
    }
    
    var body: some View {
        let theme = ThemeManager.shared.currentThemeStyle
        
        ZStack {
            VStack(spacing: 0) {
                frontSection(theme)
                
                Rectangle()
                    .fill(theme.accentColor)
                    .frame(height: 2)
                    .padding(.horizontal, 20)
                
                backSection(theme)
            }
            .frame(width: UIScreen.main.bounds.width - 40, height: 480)
            .background(theme.backgroundBlockColor)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(theme.accentColor.opacity(0.2), lineWidth: 1)
            )
            .shadow(color: theme.accentColor.opacity(0.1), radius: 10, x: 0, y: 5)
            .if(card.isSpecial) { view in
                view.applySpecialEffects(specialService.getModifiers())
            }
            swipeOverlays
        }
        .offset(x: offset + dragState.translation.width, y: dragState.translation.height)
        .rotationEffect(.degrees(cardRotation))
        .gesture(makeSwipeGesture())
        .animation(.interactiveSpring(), value: dragState.translation)
    }
    
    @ViewBuilder
    private func frontSection(_ theme: ThemeStyle) -> some View {
        VStack {
            HStack {
                Text("Front")
                    .font(.caption)
                    .foregroundColor(theme.secondaryTextColor)
                    .padding(.top, 16)
                
                Spacer()
                
                hintButton(theme)
            }
            .padding(.horizontal, 24)
            
            if showHint {
                hintView(theme)
            }
            
            Text(card.frontWord.frontText)
                .font(.system(size: 32, weight: .bold))
                .multilineTextAlignment(.center)
                .padding(.vertical, 40)
        }
        .frame(maxWidth: .infinity)
        .background(theme.backgroundBlockColor)
    }
    
    @ViewBuilder
    private func backSection(_ theme: ThemeStyle) -> some View {
        VStack {
            Text("Back")
                .font(.caption)
                .foregroundColor(theme.secondaryTextColor)
                .padding(.top, 16)
            
            Text(card.backText)
                .font(.system(size: 32, weight: .bold))
                .multilineTextAlignment(.center)
                .padding(.vertical, 40)
        }
        .frame(maxWidth: .infinity)
        .background(theme.backgroundBlockColor)
    }
    
    @ViewBuilder
    private func hintButton(_ theme: ThemeStyle) -> some View {
        if let hint = card.frontWord.hint, !hint.isEmpty {
            Button(action: handleHintTap) {
                Image(systemName: "lightbulb.fill")
                    .font(.title3)
                    .foregroundColor(showHint ? .yellow : theme.accentColor)
            }
            .padding(.top, 16)
        }
    }
    
    @ViewBuilder
    private func hintView(_ theme: ThemeStyle) -> some View {
        if let hint = card.frontWord.hint {
            VStack(spacing: 4) {
                Text("-5 points")
                    .font(.caption2)
                    .foregroundColor(theme.secondaryTextColor)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(
                        Capsule()
                            .fill(Color.yellow.opacity(0.1))
                    )
                
                Text(hint)
                    .font(.system(size: 14))
                    .foregroundColor(theme.secondaryTextColor)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 8)
            .transition(.move(edge: .top).combined(with: .opacity))
        }
    }
    
    private var swipeOverlays: some View {
        ZStack {
            VStack {
                Text(LanguageManager.shared.localizedString(for: "False").uppercased())
                    .font(.system(size: 48, weight: .heavy))
                    .foregroundColor(.red)
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.red.opacity(0.15))
                    )
            }
            .rotationEffect(.degrees(-30))
            .opacity(dragState.translation.width < 0 ? dragPercentage : 0)
            
            VStack {
                Text(LanguageManager.shared.localizedString(for: "True").uppercased())
                    .font(.system(size: 48, weight: .heavy))
                    .foregroundColor(.green)
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.green.opacity(0.15))
                    )
            }
            .rotationEffect(.degrees(30))
            .opacity(dragState.translation.width > 0 ? dragPercentage : 0)
        }
    }
    
    private func makeSwipeGesture() -> some Gesture {
        DragGesture()
            .updating($dragState) { drag, state, _ in
                state = .dragging(translation: drag.translation)
                if drag.translation.width > 50 {
                    swipeStatus = .right
                } else if drag.translation.width < -50 {
                    swipeStatus = .left
                } else {
                    swipeStatus = .none
                }
            }
            .onEnded { gesture in
                let swipeThreshold: CGFloat = 100
                if abs(gesture.translation.width) > swipeThreshold {
                    let isRight = gesture.translation.width > 0
                    if card.isSpecial && isRight == card.isMatch {
                        showSuccessEffect = true
                    }
                    onSwipe(isRight)
                }
                swipeStatus = .none
            }
    }
    
    private func handleHintTap() {
        withAnimation(.spring()) {
            if !hintWasUsed {
                hintWasUsed = true
                onHintUsed()
            }
            showHint.toggle()
        }
    }
}

extension View {
    @ViewBuilder
    func `if`(_ condition: Bool, transform: (Self) -> some View) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
