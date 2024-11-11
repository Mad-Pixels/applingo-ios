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
        let theme = ThemeManager.shared.currentThemeStyle
        
        ZStack {
            if viewModel.isLoadingCache {
                ProgressView("Loading words...")
                    .progressViewStyle(CircularProgressViewStyle())
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
                } else {
                    // Если карточки нет, но слов достаточно - генерируем новую
                    Text("Generating new card...")
                        .foregroundColor(theme.baseTextColor)
                        .onAppear {
                            generateNewCard()
                        }
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
            // Даем немного времени на заполнение кэша
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if viewModel.cache.count >= 8 {
                    generateNewCard()
                }
            }
        }
    }
    
    private func generateNewCard() {
        guard viewModel.cache.count >= 8 else {
            print("Not enough words in cache: \(viewModel.cache.count)")
            return
        }
        
        let shouldUseSameWord = Bool.random()
        let firstWord = viewModel.cache.randomElement()!
        let secondWord = shouldUseSameWord ? firstWord : viewModel.cache.filter { $0.id != firstWord.id }.randomElement()!
        
        print("Generating new card: same word = \(shouldUseSameWord)")
        
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
        
        print("Handling swipe: right = \(isRight), isMatch = \(card.isMatch)")
        
        isCorrectAnswer = isRight == card.isMatch
        
        withAnimation {
            showAnswerFeedback = true
            cardOffset = isRight ? 1000 : -1000
            cardRotation = isRight ? 20 : -20
        }
        
        viewModel.removeFromCache(card.frontWord)
        print("Removed word from cache. New count: \(viewModel.cache.count)")
        
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
    let card: VerifyCard
    let offset: CGFloat
    let rotation: Double
    let onSwipe: (Bool) -> Void
    
    @GestureState private var dragState = DragState.inactive
    
    var body: some View {
        let theme = ThemeManager.shared.currentThemeStyle
        
        VStack(spacing: 0) {
            // Верхняя часть с front_text
            Text(card.frontWord.frontText)
                .font(.title2)
                .padding()
                .frame(maxWidth: .infinity)
                .background(theme.backgroundBlockColor)
            
            Divider()
                .background(theme.accentColor)
            
            // Нижняя часть с back_text
            Text(card.backText)
                .font(.title2)
                .padding()
                .frame(maxWidth: .infinity)
                .background(theme.backgroundBlockColor)
        }
        .frame(width: UIScreen.main.bounds.width - 40, height: 200)
        .cornerRadius(12)
        .shadow(radius: 5)
        .offset(x: offset + dragState.translation.width)
        .rotationEffect(.degrees(rotation + dragState.rotation))
        .gesture(
            DragGesture()
                .updating($dragState) { drag, state, _ in
                    state = .dragging(translation: drag.translation)
                }
                .onEnded { gesture in
                    let swipeThreshold: CGFloat = 100
                    
                    if abs(gesture.translation.width) > swipeThreshold {
                        let isRight = gesture.translation.width > 0
                        onSwipe(isRight)
                    }
                }
        )
    }
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
    
    var rotation: Double {
        switch self {
        case .inactive:
            return 0
        case .dragging(let translation):
            return Double(translation.width / 20)
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
