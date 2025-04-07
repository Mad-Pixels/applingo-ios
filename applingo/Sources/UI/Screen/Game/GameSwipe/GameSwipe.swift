import SwiftUI

struct GameSwipe: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @Environment(\.dismiss) private var dismiss

    @StateObject private var viewModel: SwipeViewModel
    @StateObject private var locale = GameSwipeLocale()
    @StateObject private var style: GameSwipeStyle

    //
    @State private var currentBonusID: String? = nil

    
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
                // 🔥 1. Фоновая анимация для special бонуса
                if let bonus = viewModel.currentCard?.specialBonus,
                   bonus.id == currentBonusID {
                    bonus.backgroundEffectView
                        .ignoresSafeArea()
                        .transition(.opacity)
                }

                // 🎨 2. Overlay и фоновые элементы
                OverlayIcon.GameAnswer(themeManager.currentThemeStyle)

                // ⏳ 3. Прелоадер
                if shouldShowPreloader {
                    ItemListLoading(style: .themed(themeManager.currentThemeStyle))
                }

                // 🧠 4. Контент карточки
                if let card = viewModel.currentCard {
                    GameSwipeChoice(
                        locale: locale,
                        style: style,
                        offset: viewModel.dragOffset
                    )

                    GameSwipeCard(
                        locale: locale,
                        style: style,
                        card: card,
                        offset: viewModel.dragOffset
                    )
                    .id(card.id)
                    .transition(.scale.combined(with: .opacity))
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
                        let disabled = TTSLanguageType.shared.get(for: card.backWord.backTextCode) == ""
                        GameFloatingButtonSpeaker(word: card.backWord, disabled: disabled)
                            .padding(.bottom, style.floatingButtonPadding)
                    }
                }
            }
            .animation(.easeOut(duration: 0.5), value: viewModel.currentCard?.id)
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .onAppear {
            viewModel.generateCard()
        }
        .onChange(of: viewModel.isLoadingCard) { isLoading in
            handleLoadingStateChange(isLoading)
        }
        .onChange(of: viewModel.currentCard?.id) { _ in
            currentBonusID = viewModel.currentCard?.specialBonus?.id
        }
        .onReceive(game.state.$isGameOver) { isGameOver in
            if isGameOver {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    dismiss()
                }
            }
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
