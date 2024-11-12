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
    @EnvironmentObject var gameAction: GameActionViewModel
    
    @State private var currentCard: VerifyCardModel?
    @State private var showAnswerFeedback = false
    @State private var isCorrectAnswer = false
    @State private var cardOffset: CGFloat = 0
    @State private var cardRotation: Double = 0
    @State private var startTime: TimeInterval = 0
    @StateObject private var feedbackHandler = GameFeedbackHandler()
    @State private var hintPenalty: Int = 0
    
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
                    .shake(isShaking: feedbackHandler.isShaking)
                }
                if showAnswerFeedback {
                    VStack {
                        if currentCard?.isGolden == true && isCorrectAnswer {
                            Image(systemName: "star.circle.fill")
                                .foregroundColor(.yellow)
                                .font(.system(size: 80))
                                .transition(.scale.combined(with: .opacity))
                        } else {
                            Image(systemName: isCorrectAnswer ? "checkmark.circle.fill" : "x.circle.fill")
                                .foregroundColor(isCorrectAnswer ? .green : .red)
                                .font(.system(size: 60))
                        }
                    }
                    .zIndex(1)
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                if cacheGetter.cache.count >= 8 {
                    generateNewCard()
                }
            }
        }
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
                isMatch: shouldUseSameWord
            )
            cardOffset = 0
            cardRotation = 0
        }
    }
    
    private func handleSwipe(isRight: Bool) {
        guard let card = currentCard else { return }
        isCorrectAnswer = isRight == card.isMatch
        
        // Базовые очки за правильный ответ
        let baseScore = isCorrectAnswer ? 10 : 0
        
        // Применяем бонус за золотую карточку
        let finalScore = GoldenCardService.shared.calculateBonusScore(
            baseScore: baseScore,
            isGolden: card.isGolden
        )
        
        if !isCorrectAnswer {
            feedbackHandler.provideFeedbackForWrongAnswer()
        }
        
        let result = VerifyGameResultModel(
            word: card.frontWord,
            isCorrect: isCorrectAnswer,
            score: finalScore,
            responseTime: Date().timeIntervalSince1970 - startTime,
            isGolden: card.isGolden
        )
        gameAction.handleGameResult(result)
        
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
                VStack {
                    HStack {
                        Text("Front")
                            .font(.caption)
                            .foregroundColor(theme.secondaryTextColor)
                            .padding(.top, 16)
                        
                        Spacer()
                        
                        if let hint = card.frontWord.hint, !hint.isEmpty {
                            Button(action: {
                                withAnimation(.spring()) {
                                    if !hintWasUsed {
                                        hintWasUsed = true
                                        onHintUsed()
                                    }
                                    showHint.toggle()
                                }
                            }) {
                                Image(systemName: "lightbulb.fill")
                                    .font(.title3)
                                    .foregroundColor(showHint ? .yellow : theme.accentColor)
                            }
                            .padding(.top, 16)
                        }
                    }
                    .padding(.horizontal, 24)
                    
                    if showHint, let hint = card.frontWord.hint {
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
                    
                    Text(card.frontWord.frontText)
                        .font(.system(size: 32, weight: .bold))
                        .multilineTextAlignment(.center)
                        .padding(.vertical, 40)
                }
                .frame(maxWidth: .infinity)
                .background(theme.backgroundBlockColor)
                
                Rectangle()
                    .fill(theme.accentColor)
                    .frame(height: 2)
                    .padding(.horizontal, 20)
                
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
            .frame(width: UIScreen.main.bounds.width - 40, height: 480)
            .background(theme.backgroundBlockColor)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(theme.accentColor.opacity(0.2), lineWidth: 1)
            )
            .shadow(color: theme.accentColor.opacity(0.1), radius: 10, x: 0, y: 5)
            .goldenCard(isGolden: card.isGolden)
            .goldenCardSuccessEffect(isActive: showSuccessEffect)
            .goldenCardAppearance(isGolden: card.isGolden)
            
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
        .offset(x: offset + dragState.translation.width, y: dragState.translation.height)
        .rotationEffect(.degrees(cardRotation))
        .gesture(
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
                        
                        if card.isGolden && isRight == card.isMatch {
                            showSuccessEffect = true
                        }
                        
                        onSwipe(isRight)
                    }
                    
                    swipeStatus = .none
                }
        )
        .animation(.interactiveSpring(), value: dragState.translation)
    }
}
