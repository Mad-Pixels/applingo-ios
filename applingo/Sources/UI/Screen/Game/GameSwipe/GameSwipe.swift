import SwiftUI

struct GameSwipe: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var viewModel: SwipeViewModel
    @StateObject private var locale = GameSwipeLocale()
    @StateObject private var style: GameSwipeStyle
    
    @ObservedObject var game: Swipe
    
    @State private var shouldShowPreloader = false
    @State private var preloaderTimer: DispatchWorkItem?
    
    init(
        game: Swipe,
        style: GameSwipeStyle = .themed(ThemeManager.shared.currentThemeStyle)
    ) {
        let vm = SwipeViewModel(game: game)
        _viewModel = StateObject(wrappedValue: vm)
        _style = StateObject(wrappedValue: style)
        self.game = game
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if shouldShowPreloader {
                    ItemListLoading(style: .themed(themeManager.currentThemeStyle))
                }
                
                if let card = viewModel.currentCard {
                    cardView(for: card)
                        .offset(viewModel.dragOffset)
                        .rotationEffect(.degrees(viewModel.cardRotation))
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    viewModel.handleDragGesture(value: value)
                                }
                                .onEnded { value in
                                    viewModel.handleDragEnded(value: value)
                                }
                        )
                    
                    VStack {
                        Spacer()
                        GameFloatingBtnSpeaker(word: card.word, disabled: true)
                            .padding(.bottom, style.floatingBtnPadding)
                    }
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .onAppear {
            viewModel.generateCard()
        }
        .onChange(of: viewModel.isLoadingCard) { isLoading in
            handleLoadingStateChange(isLoading)
        }
        .onReceive(game.state.$isGameOver) { isGameOver in
            if isGameOver {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    dismiss()
                }
            }
        }
    }
    
    @ViewBuilder
    private func cardView(for card: SwipeModelCard) -> some View {
        VStack {
            HStack {
                Text("❌ Не верно")
                    .foregroundColor(.red)
                    .opacity(viewModel.dragOffset.width < -20 ? 1 : 0)
                    .animation(.easeInOut, value: viewModel.dragOffset.width)

                Spacer()

                Text("Верно ✅")
                    .foregroundColor(.green)
                    .opacity(viewModel.dragOffset.width > 20 ? 1 : 0)
                    .animation(.easeInOut, value: viewModel.dragOffset.width)
            }
            .padding(.horizontal)

            // Карточка
            ZStack {
                // 🌈 Подложка с паттерном
                GameSwipeCardBackground(
                    cornerRadius: 20,
                    style: themeManager.currentThemeStyle
                )

                // 🎨 Основной фон
                RoundedRectangle(cornerRadius: 20)
                    .fill(themeManager.currentThemeStyle.backgroundPrimary.opacity(0.8))
                    .shadow(radius: 5)

                // 🖌️ Паттерн-граница
                GameCardSwipeBorder(
                    cornerRadius: 20,
                    style: themeManager.currentThemeStyle
                )

                // Контент
                VStack(spacing: 20) {
                    Text(card.frontText)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(themeManager.currentThemeStyle.textPrimary)
                        .multilineTextAlignment(.center)
                        .padding(.top, 30)

                    Divider()
                        .background(themeManager.currentThemeStyle.accentPrimary)
                        .padding(.horizontal, 30)

                    Text(card.backText)
                        .font(.title2)
                        .foregroundColor(themeManager.currentThemeStyle.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 30)
                }
                .padding()
            }
            .frame(width: 300, height: 400)
        }
    }
    
    private func handleLoadingStateChange(_ isLoading: Bool) {
        if isLoading {
            preloaderTimer?.cancel()
            let timer = DispatchWorkItem {
                if viewModel.isLoadingCard {
                    shouldShowPreloader = true
                }
            }
            preloaderTimer = timer
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: timer)
        } else {
            preloaderTimer?.cancel()
            preloaderTimer = nil
            shouldShowPreloader = false
        }
    }
}

