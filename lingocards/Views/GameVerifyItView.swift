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
    @EnvironmentObject var viewModel: GameViewModel
    
    @State private var currentCard: VerifyCard?
    @State private var showAnswerFeedback = false
    @State private var isCorrectAnswer = false
    @State private var cardOffset: CGFloat = 0
    @State private var cardRotation: Double = 0
    
    var body: some View {
        ZStack {
            if viewModel.isLoadingCache {
                CompPreloaderView()
            } else {
                if let card = currentCard {
                    CardView(
                        card: card,
                        offset: cardOffset,
                        rotation: cardRotation,
                        onSwipe: { isRight in
                            handleSwipe(isRight: isRight)
                        }
                    )
                }
                if showAnswerFeedback {
                    VStack {
                        Image(systemName: isCorrectAnswer ? "checkmark.circle.fill" : "x.circle.fill")
                            .foregroundColor(isCorrectAnswer ? .green : .red)
                            .font(.system(size: 60))
                    }
                    .zIndex(1)
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                if viewModel.cache.count >= 8 {
                    generateNewCard()
                }
            }
        }
    }
    
    private func generateNewCard() {
        guard viewModel.cache.count >= 8 else {
            return
        }
        let shouldUseSameWord = Bool.random()
        let firstWord = viewModel.cache.randomElement()!
        let secondWord = shouldUseSameWord ? firstWord : viewModel.cache.filter {
            $0.id != firstWord.id
        }.randomElement()!
        
        withAnimation {
            currentCard = VerifyCard(
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
        withAnimation {
            showAnswerFeedback = true
            cardOffset = isRight ? 1000 : -1000
            cardRotation = isRight ? 20 : -20
        }
        viewModel.removeFromCache(card.frontWord)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
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
    let card: VerifyCard
    let offset: CGFloat
    let rotation: Double
    let onSwipe: (Bool) -> Void
    
    @GestureState private var dragState = DragState.inactive
    @State private var swipeStatus: SwipeStatus = .none
    
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
                    Text("Front")
                        .font(.caption)
                        .foregroundColor(theme.secondaryTextColor)
                        .padding(.top, 16)
                    
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
            .frame(width: UIScreen.main.bounds.width - 40, height: 480) // Увеличенная высота
            .background(theme.backgroundBlockColor)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(theme.accentColor.opacity(0.2), lineWidth: 1)
            )
            .shadow(color: theme.accentColor.opacity(0.1), radius: 10, x: 0, y: 5)
            
            ZStack {
                VStack {
                    Text("FALSE")
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
                    Text("TRUE")
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
                        onSwipe(isRight)
                    }
                    
                    swipeStatus = .none
                }
        )
        .animation(.interactiveSpring(), value: dragState.translation)
    }
}

enum SwipeStatus {
    case none
    case left
    case right
}

enum DragState {
    case inactive
    case dragging(translation: CGSize)
    
    var translation: CGSize {
        switch self {
        case .inactive:
            return .zero
        case .dragging(let translation):
            return translation
        }
    }
}

struct VerifyCard: Equatable, Identifiable {
    let id = UUID()
    let frontWord: WordItemModel
    let backText: String
    let isMatch: Bool
    
    static func == (lhs: VerifyCard, rhs: VerifyCard) -> Bool {
        lhs.id == rhs.id
    }
}
