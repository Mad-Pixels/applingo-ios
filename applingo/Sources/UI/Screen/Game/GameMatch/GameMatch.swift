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
                            ForEach(viewModel.leftOrder, id: \.self) { index in
                                GameMatchViewCard(
                                    text: viewModel.currentCards[index].question,
                                    index: index,
                                    onSelect: { viewModel.selectFront(at: index) },
                                    isSelected: viewModel.selectedFrontIndex == index,
                                    isMatched: viewModel.matchedIndices.contains(index),
                                    viewModel: viewModel
                                )
                            }
                        }
                        .padding(.horizontal, 12)

                        GameMatchViewSeparator()

                        VStack(spacing: 8) {
                            ForEach(viewModel.rightOrder, id: \.self) { index in
                                GameMatchViewCard(
                                    text: viewModel.currentCards[index].answer,
                                    index: index,
                                    onSelect: { viewModel.selectBack(at: index) },
                                    isSelected: viewModel.selectedBackIndex == index,
                                    isMatched: viewModel.matchedIndices.contains(index),
                                    viewModel: viewModel
                                )
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
