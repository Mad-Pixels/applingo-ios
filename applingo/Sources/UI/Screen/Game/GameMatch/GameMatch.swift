import SwiftUI

struct GameMatch: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @Environment(\.dismiss) private var dismiss

    @StateObject private var viewModel: GameMatchViewModel
    @StateObject private var locale = GameMatchLocale()
    @StateObject private var style: GameMatchStyle

    @ObservedObject var game: Match

    @State private var shouldShowPreloader = false
    @State private var preloaderTimer: DispatchWorkItem?

    init(
        game: Match,
        style: GameMatchStyle = .themed(ThemeManager.shared.currentThemeStyle)
    ) {
        _viewModel = StateObject(wrappedValue: GameMatchViewModel(game: game))
        _style = StateObject(wrappedValue: style)
        self.game = game
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if shouldShowPreloader {
                    ItemListLoading(style: .themed(themeManager.currentThemeStyle))
                }
                if !viewModel.currentCards.isEmpty {
                    HStack(spacing: 0) {
                        VStack(spacing: 8) {
                            ForEach(viewModel.board.leftOrder.indices, id: \.self) { position in
                                if let cardIndex = viewModel.board.leftOrder[position] {
                                    GameMatchViewCard(
                                        text: viewModel.currentCards[cardIndex].question,
                                        index: cardIndex,
                                        onSelect: { viewModel.selectFront(at: cardIndex) },
                                        isSelected: viewModel.selectedFrontIndex == cardIndex,
                                        isMatched: viewModel.matchedIndices.contains(cardIndex),
                                        viewModel: viewModel,
                                        isQuestion: true
                                    )
                                    .id("left_\(cardIndex)")
                                } else {
                                    Color.clear
                                        .frame(height: 72)
                                        .id("left_empty_\(position)")
                                }
                            }
                        }
                        .padding(.horizontal, 12)

                        GameMatchViewSeparator()

                        VStack(spacing: 8) {
                            ForEach(viewModel.board.rightOrder.indices, id: \.self) { position in
                                if let cardIndex = viewModel.board.rightOrder[position] {
                                    GameMatchViewCard(
                                        text: viewModel.currentCards[cardIndex].answer,
                                        index: cardIndex,
                                        onSelect: { viewModel.selectBack(at: cardIndex) },
                                        isSelected: viewModel.selectedBackIndex == cardIndex,
                                        isMatched: viewModel.matchedIndices.contains(cardIndex),
                                        viewModel: viewModel,
                                        isQuestion: false
                                    )
                                    .id("right_\(cardIndex)")
                                } else {
                                    Color.clear
                                        .frame(height: 72)
                                        .id("right_empty_\(position)")
                                }
                            }
                        }
                        .padding(.horizontal, 12)
                    }
                    .padding(.top, 36)
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .onAppear {
            viewModel.generateCards()
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
