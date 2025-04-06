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
                    GameSwipeChoice(
                        dragOffset: viewModel.dragOffset,
                        locale: locale
                    )
                    .zIndex(10)

                    GameSwipeCard(
                        locale: locale,
                        style: style,
                        card: card,
                        offset: viewModel.dragOffset
                    )
                    .zIndex(5)
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
                            .padding(.bottom, style.floatingButtonPadding)
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
