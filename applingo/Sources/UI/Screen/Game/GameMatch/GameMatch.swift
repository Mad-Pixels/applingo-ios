import SwiftUI

struct GameMatch: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var viewModel: GameMatchViewModel
    
    @State private var preloaderTimer: DispatchWorkItem?
    @State private var shuffledFrontIndices: [Int] = []
    @State private var shuffledBackIndices: [Int] = []
    @State private var shouldShowPreloader = false
    
    @ObservedObject var game: Match
    
    init(game: Match) {
        self._viewModel = StateObject(wrappedValue: GameMatchViewModel(game: game))
        self.game = game
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if shouldShowPreloader {
                    ItemListLoading(style: .themed(themeManager.currentThemeStyle))
                }
                
                if !viewModel.currentCards.isEmpty {
                    matchContent
                } else if viewModel.shouldShowEmptyView {
                    Text("Недостаточно слов для игры")
                        .foregroundColor(.gray)
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .onAppear {
            viewModel.generateCards()
        }
        .onChange(of: viewModel.isLoadingCard) { isLoading in
            handleLoadingStateChange(isLoading)
            shuffleIndices()
        }
        .onReceive(game.state.$isGameOver) { isGameOver in
            if isGameOver {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    dismiss()
                }
            }
        }
    }
    
    private var matchContent: some View {
        HStack(spacing: 0) {
            // Левая колонка (вопросы)
            questionsColumn
            
            // Разделитель
            separatorView
            
            // Правая колонка (ответы)
            answersColumn
        }
        .padding(.top, 36)
    }
    
    private var questionsColumn: some View {
        VStack(spacing: 4) {
            ForEach(shuffledFrontIndices, id: \.self) { index in
                GameMatchViewCard(
                    style: themeManager.currentThemeStyle.matchTheme,
                    text: viewModel.currentCards[index].question,
                    index: index,
                    isFrontCard: true,
                    onSelect: { viewModel.selectFront(at: index) },
                    viewModel: viewModel
                )
            }
        }
        .padding(.horizontal)
    }
    
    private var answersColumn: some View {
        VStack(spacing: 4) {
            ForEach(shuffledBackIndices, id: \.self) { index in
                GameMatchViewCard(
                    style: themeManager.currentThemeStyle.matchTheme,
                    text: viewModel.currentCards[index].answer,
                    index: index,
                    isFrontCard: false,
                    onSelect: { viewModel.selectBack(at: index) },
                    viewModel: viewModel
                )
            }
        }
        .padding(.horizontal)
    }
    
    private var separatorView: some View {
        ZStack {
            Rectangle()
                .fill(Color.gray.opacity(0.5))
                .frame(width: 1)
                .scaleEffect(y: 0.7)
        }
        .frame(width: 20)
    }
    
    private func shuffleIndices() {
        let indices = Array(0..<viewModel.currentCards.count)
        shuffledFrontIndices = indices.shuffled()
        shuffledBackIndices = indices.shuffled()
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
