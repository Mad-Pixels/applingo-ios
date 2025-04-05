import SwiftUI

struct GameMatch: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var viewModel: MatchViewModel
    @StateObject private var locale = GameMatchLocale()
    @StateObject private var style: GameMatchStyle
    
    @ObservedObject private var board: GameMatchBoard
    @ObservedObject var game: Match

    @State private var shouldShowPreloader = false
    @State private var preloaderTimer: DispatchWorkItem?
    @State private var selectedRightPosition: Int? = nil
    @State private var selectedLeftPosition: Int? = nil

    init(
        game: Match,
        style: GameMatchStyle = .themed(ThemeManager.shared.currentThemeStyle)
    ) {
        let vm = MatchViewModel(game: game)
        
        _viewModel = StateObject(wrappedValue: vm)
        _board = ObservedObject(wrappedValue: vm.gameBoard)
        _style = StateObject(wrappedValue: style)
        self.game = game
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if shouldShowPreloader && board.cards.isEmpty {
                    ItemListLoading(style: .themed(themeManager.currentThemeStyle))
                }

                if !board.cards.isEmpty {
                    HStack {
                        VStack(spacing: 8) {
                            ForEach(0..<board.columnLeft.count, id: \.self) { position in
                                let text = board.text(position: position, isLeft: true)
                                let highlight = viewModel.highlightedOptions[text]

                                if !text.isEmpty {
                                    GameMatchButton(
                                        text: text,
                                        action: {
                                            selectedLeftPosition = position
                                            checkForMatch()
                                        },
                                        isSelected: selectedLeftPosition == position,
                                        isMatched: false,
                                        highlightColor: highlight
                                    )
                                    .frame(height: 72)
                                } else {
                                    Color.clear.frame(height: 72)
                                }
                            }
                        }

                        GameMatchViewSeparator()

                        VStack(spacing: 8) {
                            ForEach(0..<board.columnRight.count, id: \.self) { position in
                                let text = board.text(position: position, isLeft: false)
                                let highlight = viewModel.highlightedOptions[text]

                                if !text.isEmpty {
                                    GameMatchButton(
                                        text: text,
                                        action: {
                                            selectedRightPosition = position
                                            checkForMatch()
                                        },
                                        isSelected: selectedRightPosition == position,
                                        isMatched: false,
                                        highlightColor: highlight
                                    )
                                    .frame(height: 72)
                                } else {
                                    Color.clear.frame(height: 72)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .onAppear {
            viewModel.generateCards()
        }
        .onChange(of: viewModel.isLoadingCards) { isLoading in
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

    private func checkForMatch() {
        if let left = selectedLeftPosition, let right = selectedRightPosition {
            viewModel.checkMatch(selectedLeft: left, selectedRight: right)
            selectedLeftPosition = nil
            selectedRightPosition = nil
        }
    }
    
    private func handleLoadingStateChange(_ isLoading: Bool) {
        if isLoading {
            preloaderTimer?.cancel()
            
            let timer = DispatchWorkItem {
                if viewModel.isLoadingCards {
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
