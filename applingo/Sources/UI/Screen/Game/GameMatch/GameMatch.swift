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
                    VStack(spacing: 0) {
                        ForEach(0..<viewModel.currentCards.count, id: \.self) { index in
                            GameMatchViewCard(
                                style: style,
                                text: viewModel.currentCards[index].question,
                                index: index,
                                isFrontCard: true,
                                onSelect: {
                                    viewModel.selectFront(at: index)
                                },
                                viewModel: viewModel
                            )
                            
                            GameMatchViewCard(
                                style: style,
                                text: viewModel.currentCards[index].answer,
                                index: index,
                                isFrontCard: false,
                                onSelect: {
                                    viewModel.selectFront(at: index)
                                },
                                viewModel: viewModel
                            )
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, geometry.size.height * 0.03)
                    .frame(
                        minHeight: geometry.size.height * 0.7,
                        alignment: .center
                    )
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .onAppear {
            viewModel.generateCards()
        }
        .onChange(of: viewModel.isLoadingCard) { isLoading in
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
        .onReceive(game.state.$isGameOver) { isGameOver in
            if isGameOver {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    dismiss()
                }
            }
        }
    }
}
