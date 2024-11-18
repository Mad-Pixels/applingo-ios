import SwiftUI

struct CompGameCardSwipeView: View {
    let card: GameVerifyCardModel
    let offset: CGFloat
    let rotation: Double
    let onSwipe: (Bool) -> Void
    let onHintUsed: () -> Void
    let specialService: GameSpecialService
    
    @Binding var hintState: GameHintState
    @GestureState private var dragState = GameDragStateModel.inactive
    @State private var swipeStatus: GameSwipeStatusModel = .none
    @State private var showSuccessEffect: Bool = false
    
    private let style = GameCardStyle(theme: ThemeManager.shared.currentThemeStyle)
    
    private var cardRotation: Double {
        let dragRotation = Double(dragState.translation.width / GameCardStyle.SwipeCard.dragWidthDivisor) * GameCardStyle.SwipeCard.rotationMultiplier
        let totalRotation = rotation + dragRotation
        return min(max(totalRotation, -GameCardStyle.SwipeCard.maxRotation), GameCardStyle.SwipeCard.maxRotation)
    }
    
    private var dragPercentage: Double {
        let maxDistance: CGFloat = UIScreen.main.bounds.width / 2
        let percentage = abs(dragState.translation.width) / maxDistance
        return min(max(Double(percentage), 0.0), 1.0)
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                frontSection
                style.divider()
                backSection
            }
            .gameCardStyle(style)
            .gameCardSpecialEffects(
                style: style,
                isSpecial: card.isSpecial,
                specialService: specialService
            )
            swipeOverlays
        }
        .offset(x: offset + dragState.translation.width, y: dragState.translation.height)
        .rotationEffect(.degrees(cardRotation))
        .gesture(makeSwipeGesture())
        .animation(.interactiveSpring(), value: dragState.translation)
    }
    
    private var frontSection: some View {
        VStack {
            HStack {
                style.sectionHeader("Front")
                Spacer()
                hintButton
            }
            .padding(.horizontal, GameCardStyle.Layout.horizontalPadding)
            
            if hintState.isShowing {
                hintView
            }
            style.mainText(card.frontWord.frontText)
        }
        .frame(maxWidth: .infinity)
        .background(style.theme.backgroundBlockColor)
    }
    
    private var backSection: some View {
        VStack {
            style.sectionHeader("Back")
                .padding(.horizontal, GameCardStyle.Layout.horizontalPadding)
            style.mainText(card.backText)
        }
        .frame(maxWidth: .infinity)
        .background(style.theme.backgroundBlockColor)
    }
    
    @ViewBuilder
    private var hintButton: some View {
        if let hint = card.frontWord.hint, !hint.isEmpty {
            Button(action: handleHintTap) {
                style.hintButton(isActive: hintState.isShowing)
            }
        }
    }
    
    private var hintView: some View {
        style.hintContainer {
            if let hint = card.frontWord.hint {
                style.hintPenalty()
                
                Text(hint)
                    .font(GameCardStyle.Typography.hintFont)
                    .foregroundColor(style.theme.secondaryTextColor)
                    .multilineTextAlignment(.center)
            }
        }
    }
    
    private var swipeOverlays: some View {
        ZStack {
            style.swipeOverlay(
                text: LanguageManager.shared.localizedString(for: "False"),
                color: .red,
                opacity: dragState.translation.width < 0 ? dragPercentage : 0,
                rotation: -GameCardStyle.SwipeCard.overlayRotation
            )
            style.swipeOverlay(
                text: LanguageManager.shared.localizedString(for: "True"),
                color: .green,
                opacity: dragState.translation.width > 0 ? dragPercentage : 0,
                rotation: GameCardStyle.SwipeCard.overlayRotation
            )
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
                if abs(gesture.translation.width) > GameCardStyle.SwipeCard.swipeThreshold {
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
            if !hintState.wasUsed {
                hintState.wasUsed = true
                onHintUsed()
                hintState.isShowing = true
            } else {
                hintState.isShowing.toggle()
            }
        }
    }
}
